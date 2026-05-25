import 'dart:math';
import 'models.dart';

List<String> generateTimeSlots(
  School school, {
  bool repeatSameSession = false,
  String? hari,
}) {
  final slots = <String>[];
  final sessions = school.jumlahSesiPerHari;
  if (sessions == 0) return slots;

  final jamMulai = hari != null
      ? school.getJamMulaiForHari(hari)
      : school.jamMulai;
  final jamSelesai = hari != null
      ? school.getJamSelesaiForHari(hari)
      : school.jamSelesai;

  final startH = int.parse(jamMulai.split(':')[0]);
  final startM = int.parse(jamMulai.split(':')[1]);
  final endH = int.parse(jamSelesai.split(':')[0]);
  final endM = int.parse(jamSelesai.split(':')[1]);
  var current = startH * 60 + startM;
  final end = endH * 60 + endM;

  final breakRanges = school
      .getNormalizedIstirahatForHari(hari ?? school.hariAktif.first)
      .where((b) => b.isValid)
      .map((b) {
        final start =
            int.parse(b.dari.split(':')[0]) * 60 +
            int.parse(b.dari.split(':')[1]);
        final finish =
            int.parse(b.sampai.split(':')[0]) * 60 +
            int.parse(b.sampai.split(':')[1]);
        return [start, finish];
      })
      .where((range) => range[0] < end && range[1] > current)
      .map((range) {
        final clippedStart = range[0] < current ? current : range[0];
        final clippedEnd = range[1] > end ? end : range[1];
        return [clippedStart, clippedEnd];
      })
      .toList();

  breakRanges.sort((a, b) => a[0].compareTo(b[0]));

  final mergedBreaks = <List<int>>[];
  for (final range in breakRanges) {
    if (mergedBreaks.isEmpty || range[0] > mergedBreaks.last[1]) {
      mergedBreaks.add(range);
      continue;
    }

    final last = mergedBreaks.last;
    if (range[1] > last[1]) {
      mergedBreaks[mergedBreaks.length - 1] = [last[0], range[1]];
    }
  }

  bool addSlot() {
    if (current + school.durasiSesi > end || slots.length >= sessions) {
      return false;
    }
    final h = (current ~/ 60).toString().padLeft(2, '0');
    final m = (current % 60).toString().padLeft(2, '0');
    final h2 = ((current + school.durasiSesi) ~/ 60).toString().padLeft(2, '0');
    final m2 = ((current + school.durasiSesi) % 60).toString().padLeft(2, '0');
    slots.add('$h:$m-$h2:$m2');
    current += school.durasiSesi;
    return true;
  }

  for (final breakRange in mergedBreaks) {
    while (current + school.durasiSesi <= breakRange[0] &&
        slots.length < sessions) {
      addSlot();
    }
    if (current < breakRange[1]) {
      current = breakRange[1];
    }
  }

  while (current + school.durasiSesi <= end && slots.length < sessions) {
    addSlot();
  }

  return slots;
}

List<Gene> createRandomChromosome(
  List<Subject> mapel,
  List<String> hariAktif,
  List<String> timeSlots,
  int jumlahRuang,
) {
  final genes = <Gene>[];
  for (final m in mapel) {
    for (int i = 0; i < m.jamPerMinggu; i++) {
      genes.add(
        Gene(
          mapelId: m.id,
          mapelNama: m.nama,
          kelas: m.kelas,
          guru: m.guru,
          hari: hariAktif[Random().nextInt(hariAktif.length)],
          slot: timeSlots[Random().nextInt(timeSlots.length)],
          ruang: Random().nextInt(jumlahRuang) + 1,
        ),
      );
    }
  }
  return genes;
}

int calculateFitness(
  List<Gene> chromosome,
  List<Teacher> guru,
  School school,
  Constraints constraints,
  Map<String, int> subjectWeightByName,
) {
  int conflicts = 0;

  final seen = <String, bool>{};
  int slotIndexParse(String slot) {
    // slot format: HH:mm-HH:mm
    final start = slot.split('-').first.trim();
    final parts = start.split(':');
    if (parts.length != 2) return 0;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    return h * 60 + m;
  }

  final daySlots = generateTimeSlots(school);
  final slotSortMap = <String, int>{
    for (final s in daySlots) s: slotIndexParse(s),
  };

  // Bentrok / duplikasi pada waktu yang sama
  for (final gene in chromosome) {
    final guruKey = '${gene.guru}-${gene.hari}-${gene.slot}';
    final kelasKey = '${gene.kelas}-${gene.hari}-${gene.slot}';
    final ruangKey = 'ruang${gene.ruang}-${gene.hari}-${gene.slot}';

    if (constraints.guruTidakBentrok) {
      if (seen[guruKey] == true) {
        conflicts += 10;
      } else {
        seen[guruKey] = true;
      }
    }

    if (constraints.kelasTidakBentrok) {
      if (seen[kelasKey] == true) {
        conflicts += 10;
      } else {
        seen[kelasKey] = true;
      }
    }

    if (constraints.ruangTidakBentrok) {
      if (seen[ruangKey] == true) {
        conflicts += 5;
      } else {
        seen[ruangKey] = true;
      }
    }
  }

  // Preferensi & larangan mengajar pada hari tertentu
  if (constraints.prioritasPreferensiGuru) {
    for (final gene in chromosome) {
      final g = guru.firstWhere(
        (t) => t.nama == gene.guru,
        orElse: () => Teacher(
          id: 0,
          nama: '',
          mapel: [],
          maxJamPerHari: 0,
          preferensiHari: [],
          hariTidakBisa: [],
        ),
      );
      if (g.nama.isEmpty) continue;

      if (g.hariTidakBisa.contains(gene.hari)) {
        conflicts += 25;
      } else if (!g.preferensiHari.contains(gene.hari)) {
        conflicts += 2;
      }
    }
  }

  // Maks jam per hari guru
  final jamPerHariGuru = <String, Map<String, int>>{};
  for (final gene in chromosome) {
    jamPerHariGuru.putIfAbsent(gene.guru, () => {});
    jamPerHariGuru[gene.guru]!.update(
      gene.hari,
      (v) => v + 1,
      ifAbsent: () => 1,
    );
  }

  for (final g in guru) {
    final byDay = jamPerHariGuru[g.nama];
    if (byDay == null) continue;

    for (final entry in byDay.entries) {
      final used = entry.value;
      if (used > g.maxJamPerHari) {
        conflicts += (used - g.maxJamPerHari) * 8;
      }
    }
  }

  // Minim jam kosong: untuk tiap kelas per hari, penalti jika ada gap di slot yang dipakai
  if (constraints.hindariJamKosong) {
    final usedByKelasHari = <String, Map<String, List<String>>>{};

    for (final gene in chromosome) {
      usedByKelasHari
          .putIfAbsent(gene.kelas, () => {})
          .putIfAbsent(gene.hari, () => [])
          .add(gene.slot);
    }

    for (final kelasEntry in usedByKelasHari.entries) {
      for (final hariEntry in kelasEntry.value.entries) {
        final slots = hariEntry.value.toSet().toList();
        slots.sort(
          (a, b) => (slotSortMap[a] ?? 0).compareTo(slotSortMap[b] ?? 0),
        );
        if (slots.length <= 1) continue;

        // gap: hitung jumlah slot di antaranya yang seharusnya terisi jika ada jeda besar.
        // Karena model slot adalah contiguous time blocks, kita penalti gap ukuran waktu.
        for (int i = 0; i < slots.length - 1; i++) {
          final idxA = daySlots.indexWhere((x) => x == slots[i]);
          final idxB = daySlots.indexWhere((x) => x == slots[i + 1]);
          if (idxA == -1 || idxB == -1) continue;
          final gap = (idxB - idxA - 1);
          if (gap > 0) {
            conflicts += gap * 3;
          }
        }
      }
    }
  }

  // Berat per hari (berdasarkan mapping subjectWeightByName; default 1)
  if (constraints.maxBeratPerHari > 0) {
    final beratByKelasHari = <String, Map<String, int>>{};
    for (final gene in chromosome) {
      final w = subjectWeightByName[gene.mapelNama.toLowerCase()] ?? 1;
      beratByKelasHari
          .putIfAbsent(gene.kelas, () => {})
          .update(gene.hari, (v) => v + w, ifAbsent: () => w);
    }

    for (final kelasEntry in beratByKelasHari.entries) {
      for (final hariEntry in kelasEntry.value.entries) {
        if (hariEntry.value > constraints.maxBeratPerHari * 10) {
          // skala agar konsisten dengan penalti lain (cukup longgar)
          conflicts += (hariEntry.value - constraints.maxBeratPerHari * 10) * 2;
        }
      }
    }
  }

  // Skor: semakin kecil konflik semakin baik.
  return max(0, 1000 - conflicts);
}

List<Gene> crossover(List<Gene> parent1, List<Gene> parent2) {
  final point = Random().nextInt(parent1.length);
  return [...parent1.sublist(0, point), ...parent2.sublist(point)];
}

List<Gene> mutate(
  List<Gene> chromosome,
  double mutationRate,
  List<String> hariAktif,
  List<String> timeSlots,
  int jumlahRuang,
) {
  return chromosome.map((gene) {
    if (Random().nextDouble() < mutationRate) {
      final r = Random().nextDouble();
      if (r < 0.33) {
        return Gene(
          mapelId: gene.mapelId,
          mapelNama: gene.mapelNama,
          kelas: gene.kelas,
          guru: gene.guru,
          hari: hariAktif[Random().nextInt(hariAktif.length)],
          slot: gene.slot,
          ruang: gene.ruang,
        );
      } else if (r < 0.66) {
        return Gene(
          mapelId: gene.mapelId,
          mapelNama: gene.mapelNama,
          kelas: gene.kelas,
          guru: gene.guru,
          hari: gene.hari,
          slot: timeSlots[Random().nextInt(timeSlots.length)],
          ruang: gene.ruang,
        );
      } else {
        return Gene(
          mapelId: gene.mapelId,
          mapelNama: gene.mapelNama,
          kelas: gene.kelas,
          guru: gene.guru,
          hari: gene.hari,
          slot: gene.slot,
          ruang: Random().nextInt(jumlahRuang) + 1,
        );
      }
    }
    return gene;
  }).toList();
}

Future<GAResult> runGeneticAlgorithm(
  List<Subject> mapel,
  List<Teacher> guru,
  School school,
  Constraints constraints,
  GAConfig gaConfig,
) async {
  final timeSlots = generateTimeSlots(school);
  final populationSize = gaConfig.populationSize;
  final mutationRate = gaConfig.mutationRate;
  final crossoverRate = gaConfig.crossoverRate;
  final maxGeneration = gaConfig.maxGeneration;
  final eliteSize = gaConfig.eliteSize;

  var population = List<List<Gene>>.generate(
    populationSize,
    (_) => createRandomChromosome(
      mapel,
      school.hariAktif,
      timeSlots,
      school.jumlahRuang,
    ),
  );

  final fitnessHistory = <FitnessHistory>[];
  List<Gene>? bestChromosome;
  int bestFitness = -1;
  int gen = 0;

  // Heuristik berat mapel per nama (sementara 1 untuk semua).
  // Nanti bisa dikembangkan dari data kurikulum/jenjang.
  final subjectWeightByName = <String, int>{};

  while (gen < maxGeneration) {
    final scored =
        population.map((c) {
          final fitness = calculateFitness(
            c,
            guru,
            school,
            constraints,
            subjectWeightByName,
          );
          return {'chromosome': c, 'fitness': fitness};
        }).toList()..sort(
          (a, b) => (b['fitness'] as int).compareTo(a['fitness'] as int),
        );

    final currentBest = scored[0]['fitness'] as int;
    if (currentBest > bestFitness) {
      bestFitness = currentBest;
      bestChromosome = scored[0]['chromosome'] as List<Gene>;
    }

    final avg =
        (scored.map((x) => x['fitness'] as int).reduce((a, b) => a + b) /
                scored.length)
            .round();
    fitnessHistory.add(
      FitnessHistory(gen: gen, fitness: currentBest, avg: avg.toDouble()),
    );

    if (gen >= maxGeneration - 1) break;

    final elite = scored
        .sublist(0, min(eliteSize, scored.length))
        .map((x) => x['chromosome'] as List<Gene>)
        .toList();
    final newPop = <List<Gene>>[...elite];

    while (newPop.length < populationSize) {
      final p1 =
          scored[min(
                Random().nextInt(min(10, scored.length)),
                scored.length - 1,
              )]['chromosome']
              as List<Gene>;
      final p2 =
          scored[min(
                Random().nextInt(min(10, scored.length)),
                scored.length - 1,
              )]['chromosome']
              as List<Gene>;
      final child = Random().nextDouble() < crossoverRate
          ? crossover(p1, p2)
          : [...p1];
      newPop.add(
        mutate(
          child,
          mutationRate,
          school.hariAktif,
          timeSlots,
          school.jumlahRuang,
        ),
      );
    }

    population = newPop;
    gen++;

    // Yield to allow UI updates
  }
  await Future.delayed(Duration(seconds: 5));

  return GAResult(
    gene: bestChromosome,
    fitnessHistory: fitnessHistory,
    bestFitness: bestFitness,
  );
}

class GAResult {
  final List<Gene>? gene;
  final List<FitnessHistory> fitnessHistory;
  final int bestFitness;

  const GAResult({
    required this.gene,
    required this.fitnessHistory,
    required this.bestFitness,
  });
}
