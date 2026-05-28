enum SchoolLevel {
  sd('SD', 'Sekolah Dasar', 1, 6, 35, '07:00', '12:00', 6),
  smp('SMP', 'Sekolah Menengah Pertama', 7, 9, 40, '07:00', '14:00', 8),
  sma('SMA', 'Sekolah Menengah Atas', 10, 12, 45, '07:00', '15:00', 12);

  const SchoolLevel(
    this.code,
    this.name,
    this.minGrade,
    this.maxGrade,
    this.defaultSessionDuration,
    this.defaultStartTime,
    this.defaultEndTime,
    this.defaultClassrooms,
  );

  final String code;
  final String name;
  final int minGrade;
  final int maxGrade;
  final int defaultSessionDuration;
  final String defaultStartTime;
  final String defaultEndTime;
  final int defaultClassrooms;

  // Mengubah angka tingkatan menjadi string (Romawi untuk SMP/SMA, Angka Biasa untuk SD)
  String _formatGrade(int grade) {
    if (this == SchoolLevel.sd) {
      return grade.toString(); // Output: "1", "2", dst.
    } else {
      return _toRoman(grade); // Output: "VII", "X", dst.
    }
  }

  // SEKARANG HANYA MENGHASILKAN DAFTAR TINGKATAN SAJA (Contoh: ["1", "2", ...], ["VII", "VIII", ...])
  List<String> get gradeClasses {
    final classes = <String>[];
    for (int grade = minGrade; grade <= maxGrade; grade++) {
      classes.add(_formatGrade(grade));
    }
    return classes;
  }

  // SEKARANG MENGHASILKAN DAFTAR TINGKATAN SESUAI DENGAN JUMLAH YANG DIMINTA
  List<String> defaultClasses({int count = 3}) {
    final classes = <String>[];
    for (int grade = minGrade; grade <= maxGrade; grade++) {
      classes.add(_formatGrade(grade));
    }
    // Mengambil sebanyak jumlah 'count' yang diminta, atau sebanyak tingkatan yang tersedia
    return classes.take(count).toList();
  }

  // Fungsi pembantu konversi ke Romawi
  static String _toRoman(int number) {
    if (number <= 0) return '';
    final map = <int, String>{
      1000: 'M',
      900: 'CM',
      500: 'D',
      400: 'CD',
      100: 'C',
      90: 'XC',
      50: 'L',
      40: 'XL',
      10: 'X',
      9: 'IX',
      5: 'V',
      4: 'IV',
      1: 'I',
    };

    var n = number;
    final out = <String>[];
    for (final entry in map.entries) {
      final value = entry.key;
      while (n >= value) {
        out.add(entry.value);
        n -= value;
      }
    }

    return out.join();
  }

  List<String> get coreSubjects {
    switch (this) {
      case SchoolLevel.sd:
        return [
          'Bahasa Indonesia',
          'Matematika',
          'IPA',
          'IPS',
          'Bahasa Inggris',
          'PKN',
          'Agama',
          'Seni Budaya',
          'Penjasorkes',
          'Bahasa Daerah',
        ];
      case SchoolLevel.smp:
        return [
          'Bahasa Indonesia',
          'Matematika',
          'IPA',
          'IPS',
          'Bahasa Inggris',
          'PKN',
          'Agama',
          'Seni Budaya',
          'Penjasorkes',
          'Prakarya',
          'Bahasa Asing Lainnya',
        ];
      case SchoolLevel.sma:
        return [
          'Bahasa Indonesia',
          'Matematika',
          'Bahasa Inggris',
          'PKN',
          'Agama',
          'Sejarah',
          'Sosiologi',
          'Ekonomi',
          'Geografi',
          'Fisika',
          'Kimia',
          'Biologi',
          'Seni Budaya',
          'Penjasorkes',
          'Prakarya',
          'Bahasa Asing Lainnya',
        ];
    }
  }

  int get typicalSessionsPerDay {
    switch (this) {
      case SchoolLevel.sd:
        return 5;
      case SchoolLevel.smp:
        return 6;
      case SchoolLevel.sma:
        return 7;
    }
  }

  int get minSessions {
    switch (this) {
      case SchoolLevel.sd:
        return 4;
      case SchoolLevel.smp:
        return 5;
      case SchoolLevel.sma:
        return 5;
    }
  }

  int get maxSessions {
    switch (this) {
      case SchoolLevel.sd:
        return 6;
      case SchoolLevel.smp:
        return 8;
      case SchoolLevel.sma:
        return 8;
    }
  }
}

class SchoolBreak {
  final String dari;
  final String sampai;

  SchoolBreak({required this.dari, required this.sampai});

  int? get startMinutes => _parseTime(dari);
  int? get endMinutes => _parseTime(sampai);
  bool get isValid =>
      startMinutes != null && endMinutes != null && endMinutes! > startMinutes!;

  int get durationMinutes {
    final start = startMinutes;
    final end = endMinutes;
    if (start == null || end == null) return 0;
    final diff = end - start;
    return diff > 0 ? diff : 0;
  }

  SchoolBreak copyWith({String? dari, String? sampai}) {
    return SchoolBreak(dari: dari ?? this.dari, sampai: sampai ?? this.sampai);
  }

  static int? _parseTime(String value) {
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return hour * 60 + minute;
  }
}

class School {
  String nama;
  SchoolLevel level;
  String kelas;
  List<String> kelasList;
  Map<String, List<String>> kelasSubclasses;
  Map<String, List<String>> kelasRooms;
  int jumlahHari;
  List<String> hariAktif;
  String jamMulai;
  String jamSelesai;
  Map<String, String> jamMulaiPerHari;
  Map<String, String> jamSelesaiPerHari;
  int durasiSesi;
  int jumlahSesi;
  Map<String, List<SchoolBreak>> istirahatPerHari;
  List<int> durasiSesiList;
  bool samaDurasiSesi;
  int jumlahRuang;
  List<String> daftarRuang;

  School({
    required this.nama,
    required this.level,
    required this.kelas,
    required this.kelasList,
    required this.kelasSubclasses,
    required this.kelasRooms,
    required this.jumlahHari,
    required this.hariAktif,
    required this.jamMulai,
    required this.jamSelesai,
    required this.jamMulaiPerHari,
    required this.jamSelesaiPerHari,
    required this.durasiSesi,
    required this.jumlahSesi,
    required this.istirahatPerHari,
    required this.durasiSesiList,
    required this.samaDurasiSesi,
    required this.jumlahRuang,
    required this.daftarRuang,
  });

  School copyWith({
    String? nama,
    SchoolLevel? level,
    String? kelas,
    List<String>? kelasList,
    Map<String, List<String>>? kelasSubclasses,
    Map<String, List<String>>? kelasRooms,
    int? jumlahHari,
    List<String>? hariAktif,
    String? jamMulai,
    String? jamSelesai,
    Map<String, String>? jamMulaiPerHari,
    Map<String, String>? jamSelesaiPerHari,
    int? durasiSesi,
    int? jumlahSesi,
    Map<String, List<SchoolBreak>>? istirahatPerHari,
    List<int>? durasiSesiList,
    bool? samaDurasiSesi,
    int? jumlahRuang,
    List<String>? daftarRuang,
  }) {
    final effectiveKelasList = kelasList ?? this.kelasList;
    final effectiveKelas =
        kelas ??
        (effectiveKelasList.isNotEmpty ? effectiveKelasList.first : this.kelas);
    final effectiveKelasSubclasses = kelasSubclasses ?? this.kelasSubclasses;

    return School(
      nama: nama ?? this.nama,
      level: level ?? this.level,
      kelas: effectiveKelas,
      kelasList: effectiveKelasList,
      kelasSubclasses: effectiveKelasSubclasses,
      kelasRooms: kelasRooms ?? this.kelasRooms,
      jumlahHari: jumlahHari ?? this.jumlahHari,
      hariAktif: hariAktif ?? this.hariAktif,
      jamMulai: jamMulai ?? this.jamMulai,
      jamSelesai: jamSelesai ?? this.jamSelesai,
      jamMulaiPerHari: jamMulaiPerHari ?? this.jamMulaiPerHari,
      jamSelesaiPerHari: jamSelesaiPerHari ?? this.jamSelesaiPerHari,
      durasiSesi: durasiSesi ?? this.durasiSesi,
      jumlahSesi: jumlahSesi ?? this.jumlahSesi,
      istirahatPerHari: istirahatPerHari ?? this.istirahatPerHari,
      durasiSesiList: durasiSesiList ?? this.durasiSesiList,
      samaDurasiSesi: samaDurasiSesi ?? this.samaDurasiSesi,
      jumlahRuang: jumlahRuang ?? this.jumlahRuang,
      daftarRuang: daftarRuang ?? this.daftarRuang,
    );
  }

  List<SchoolBreak> getIstirahatForHari(String hari) {
    return istirahatPerHari[hari] ?? [];
  }

  List<SchoolBreak> getNormalizedIstirahatForHari(String hari) {
    final validBreaks = getIstirahatForHari(
      hari,
    ).where((b) => b.isValid).toList();
    validBreaks.sort((a, b) => a.startMinutes!.compareTo(b.startMinutes!));

    final merged = <SchoolBreak>[];
    for (final item in validBreaks) {
      if (merged.isEmpty) {
        merged.add(item);
        continue;
      }

      final last = merged.last;
      final lastEnd = last.endMinutes!;
      final currentStart = item.startMinutes!;
      final currentEnd = item.endMinutes!;

      if (currentStart <= lastEnd) {
        final combinedEnd = lastEnd >= currentEnd ? lastEnd : currentEnd;
        merged[merged.length - 1] = SchoolBreak(
          dari: last.dari,
          sampai:
              '${(combinedEnd ~/ 60).toString().padLeft(2, '0')}:${(combinedEnd % 60).toString().padLeft(2, '0')}',
        );
      } else {
        merged.add(item);
      }
    }

    return merged;
  }

  String getJamMulaiForHari(String hari) {
    return jamMulaiPerHari[hari] ?? jamMulai;
  }

  String getJamSelesaiForHari(String hari) {
    return jamSelesaiPerHari[hari] ?? jamSelesai;
  }

  List<int> get sesiDurations {
    if (durasiSesiList.isNotEmpty) return durasiSesiList;
    return [durasiSesi];
  }

  int get jumlahSesiPerHari {
    final minSessions = level.minSessions;
    final maxSessions = level.maxSessions;

    if (jumlahSesi > 0) {
      return jumlahSesi.clamp(minSessions, maxSessions);
    }

    final startParts = jamMulai.split(':');
    final endParts = jamSelesai.split(':');
    final startMinutes =
        int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
    final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
    final totalMinutes = endMinutes - startMinutes;

    if (durasiSesi <= 0) {
      return minSessions;
    }

    // Normalisasi istirahat: karena model menyimpan istirahat per-hari,
    // gunakan istirahat hari pertama sebagai baseline perhitungan jumlah sesi.
    final firstHari = hariAktif.isNotEmpty ? hariAktif.first : 'Senin';
    final normalized = getNormalizedIstirahatForHari(firstHari);

    final breakMinutes = normalized.fold<int>(0, (sum, b) {
      final breakStart = b.startMinutes!;
      final breakEnd = b.endMinutes!;
      final clippedStart = breakStart < startMinutes
          ? startMinutes
          : breakStart;
      final clippedEnd = breakEnd > endMinutes ? endMinutes : breakEnd;
      if (clippedEnd <= clippedStart) return sum;
      return sum + clippedEnd - clippedStart;
    });

    final availableMinutes = totalMinutes - breakMinutes;
    final sessions = (availableMinutes / durasiSesi).floor();
    return sessions.clamp(minSessions, maxSessions);
  }

  List<String> get sesiSlots {
    final sessions = jumlahSesiPerHari;
    return List.generate(sessions, (i) => 'Sesi ${i + 1}');
  }

  // Get available grades for this school level
  List<String> get availableGrades {
    return kelasList.isNotEmpty ? kelasList : level.gradeClasses;
  }

  // Get recommended subjects for this school level
  List<String> get recommendedSubjects {
    return level.coreSubjects;
  }
}

class Subject {
  int id;
  String nama;

  /// Section class mapel (contoh: "10", "11", "12").
  /// UI multi-select menyimpan ini di sini.
  List<String> kelas;

  int jamPerMinggu;
  String guru;
  int durasiPerSesi; // dalam menit

  Subject({
    required this.id,
    required this.nama,
    required this.kelas,
    required this.jamPerMinggu,
    required this.guru,
    this.durasiPerSesi = 45, // default 45 menit
  });

  Subject copyWith({
    int? id,
    String? nama,
    List<String>? kelas,
    int? jamPerMinggu,
    String? guru,
    int? durasiPerSesi,
  }) {
    return Subject(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kelas: kelas ?? this.kelas,
      jamPerMinggu: jamPerMinggu ?? this.jamPerMinggu,
      guru: guru ?? this.guru,
      durasiPerSesi: durasiPerSesi ?? this.durasiPerSesi,
    );
  }
}

class Teacher {
  int id;
  String nama;
  List<String> mapel;
  int maxJamPerHari;
  List<String> preferensiHari;
  List<String> hariTidakBisa;

  Teacher({
    required this.id,
    required this.nama,
    required this.mapel,
    required this.maxJamPerHari,
    required this.preferensiHari,
    required this.hariTidakBisa,
  });

  Teacher copyWith({
    int? id,
    String? nama,
    List<String>? mapel,
    int? maxJamPerHari,
    List<String>? preferensiHari,
    List<String>? hariTidakBisa,
  }) {
    return Teacher(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      mapel: mapel ?? this.mapel,
      maxJamPerHari: maxJamPerHari ?? this.maxJamPerHari,
      preferensiHari: preferensiHari ?? this.preferensiHari,
      hariTidakBisa: hariTidakBisa ?? this.hariTidakBisa,
    );
  }
}

class Gene {
  int mapelId;
  String mapelNama;
  String kelas;
  String guru;
  String hari;
  String slot;
  String ruang;

  Gene({
    required this.mapelId,
    required this.mapelNama,
    required this.kelas,
    required this.guru,
    required this.hari,
    required this.slot,
    required this.ruang,
  });
}

class Constraints {
  bool guruTidakBentrok;
  bool kelasTidakBentrok;
  bool ruangTidakBentrok;
  bool hindariJamKosong;
  bool prioritasPreferensiGuru;
  int maxBeratPerHari;
  int maxBerturutan;

  /// Jika enabled: setiap kelas harus selalu memakai [fixedClassToRoom] yang sesuai.
  ///
  /// Key: kelas (contoh: "10-A")
  /// Value: nama ruangan (contoh: "Ruang 1")
  bool fixedClassEnabled;
  Map<String, String> fixedClassToRoom;

  Constraints({
    required this.guruTidakBentrok,
    required this.kelasTidakBentrok,
    required this.ruangTidakBentrok,
    required this.hindariJamKosong,
    required this.prioritasPreferensiGuru,
    required this.maxBeratPerHari,
    required this.maxBerturutan,
    required this.fixedClassEnabled,
    required this.fixedClassToRoom,
  });

  Constraints copyWith({
    bool? guruTidakBentrok,
    bool? kelasTidakBentrok,
    bool? ruangTidakBentrok,
    bool? hindariJamKosong,
    bool? prioritasPreferensiGuru,
    int? maxBeratPerHari,
    int? maxBerturutan,
    bool? fixedClassEnabled,
    Map<String, String>? fixedClassToRoom,
  }) {
    return Constraints(
      guruTidakBentrok: guruTidakBentrok ?? this.guruTidakBentrok,
      kelasTidakBentrok: kelasTidakBentrok ?? this.kelasTidakBentrok,
      ruangTidakBentrok: ruangTidakBentrok ?? this.ruangTidakBentrok,
      hindariJamKosong: hindariJamKosong ?? this.hindariJamKosong,
      prioritasPreferensiGuru:
          prioritasPreferensiGuru ?? this.prioritasPreferensiGuru,
      maxBeratPerHari: maxBeratPerHari ?? this.maxBeratPerHari,
      maxBerturutan: maxBerturutan ?? this.maxBerturutan,
      fixedClassEnabled: fixedClassEnabled ?? this.fixedClassEnabled,
      fixedClassToRoom: fixedClassToRoom ?? this.fixedClassToRoom,
    );
  }
}

class GAConfig {
  int populationSize;
  double mutationRate;
  double crossoverRate;
  int maxGeneration;
  int eliteSize;

  GAConfig({
    required this.populationSize,
    required this.mutationRate,
    required this.crossoverRate,
    required this.maxGeneration,
    required this.eliteSize,
  });

  GAConfig copyWith({
    int? populationSize,
    double? mutationRate,
    double? crossoverRate,
    int? maxGeneration,
    int? eliteSize,
  }) {
    return GAConfig(
      populationSize: populationSize ?? this.populationSize,
      mutationRate: mutationRate ?? this.mutationRate,
      crossoverRate: crossoverRate ?? this.crossoverRate,
      maxGeneration: maxGeneration ?? this.maxGeneration,
      eliteSize: eliteSize ?? this.eliteSize,
    );
  }
}

class FitnessHistory {
  int gen;
  int fitness;
  double avg;

  FitnessHistory({required this.gen, required this.fitness, required this.avg});
}
