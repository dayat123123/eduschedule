import 'dart:ui';
import 'package:eduschedule/theme.dart';
import 'package:flutter/material.dart';

import '../ga.dart';
import '../models.dart';
import '../widgets/form_widgets.dart';

class FormScreen extends StatefulWidget {
  final int step;
  final School school;
  final List<Subject> mapel;
  final List<Teacher> guru;
  final Constraints constraints;
  final GAConfig gaConfig;
  final Function(int) onStepChange;
  final Function(School) onSchoolChange;
  final Function(List<Subject>) onMapelChange;
  final Function(List<Teacher>) onGuruChange;
  final Function(Constraints) onConstraintsChange;
  final Function(GAConfig) onGAConfigChange;
  final VoidCallback onGenerate;
  final VoidCallback onBackToHero;

  const FormScreen({
    super.key,
    required this.step,
    required this.school,
    required this.mapel,
    required this.guru,
    required this.constraints,
    required this.gaConfig,
    required this.onStepChange,
    required this.onSchoolChange,
    required this.onMapelChange,
    required this.onGuruChange,
    required this.onConstraintsChange,
    required this.onGAConfigChange,
    required this.onGenerate,
    required this.onBackToHero,
  });

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<String> steps = [
    "Info Sekolah",
    "Mata Pelajaran",
    "Data Guru",
    "Aturan Jadwal",
    "Konfigurasi GA",
  ];

  final List<String> stepIcons = ["🏫", "📚", "👨‍🏫", "⚙️", "🧬"];

  final List<String> stepTitles = [
    "Pengaturan Sekolah",
    "Data Mata Pelajaran",
    "Data Guru",
    "Aturan & Constraint",
    "Konfigurasi Algoritma Genetika",
  ];

  final List<String> stepSubtitles = [
    "Isi informasi umum sekolah Anda",
    "Tambahkan semua mata pelajaran yang perlu dijadwalkan",
    "Masukkan data guru beserta preferensi mengajar",
    "Tentukan aturan-aturan yang harus dipenuhi jadwal",
    "Atur parameter algoritma genetika untuk optimasi jadwal",
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget getStepContent() {
    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          surface: Colors.white,
        ),
      ),
      child: _buildRawStepContent(),
    );
  }

  Widget _buildRawStepContent() {
    switch (widget.step) {
      case 0:
        return FormSekolah(
          data: widget.school,
          onChange: widget.onSchoolChange,
        );

      case 1:
        return FormMapel(
          data: widget.mapel,
          onChange: widget.onMapelChange,
          school: widget.school,
        );

      case 2:
        return FormGuru(
          data: widget.guru,
          onChange: widget.onGuruChange,
          subjectOptions: widget.mapel
              .map((subject) => subject.nama)
              .toSet()
              .toList(),
          hariOptions: widget.school.hariAktif,
        );

      case 3:
        return FormConstraints(
          data: widget.constraints,
          onChange: widget.onConstraintsChange,
        );

      case 4:
        return FormGAConfig(
          data: widget.gaConfig,
          onChange: widget.onGAConfigChange,
        );

      default:
        return const SizedBox();
    }
  }

  int? _parseMinutes(String value) {
    final parts = value.split(':');

    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

    return hour * 60 + minute;
  }

  String norm(String s) => s.trim().replaceAll(RegExp(r'\s+'), ' ');

  String? _validateSchool(School data) {
    if (data.nama.trim().isEmpty) {
      return 'Nama sekolah tidak boleh kosong.';
    }

    if (data.jumlahHari <= 0) {
      return 'Jumlah hari sekolah harus lebih besar dari 0.';
    }

    if (data.hariAktif.isEmpty) {
      return 'Pilih minimal satu hari aktif sekolah.';
    }

    if (data.hariAktif.length != data.jumlahHari) {
      return 'Jumlah hari aktif harus sesuai dengan jumlah hari sekolah.';
    }

    final start = _parseMinutes(data.jamMulai);
    final end = _parseMinutes(data.jamSelesai);

    if (start == null) {
      return 'Format jam mulai harus HH:mm.';
    }

    if (end == null) {
      return 'Format jam selesai harus HH:mm.';
    }

    if (end <= start) {
      return 'Jam selesai harus lebih besar dari jam mulai.';
    }

    for (final hari in data.hariAktif) {
      final dayStart = _parseMinutes(data.getJamMulaiForHari(hari));
      final dayEnd = _parseMinutes(data.getJamSelesaiForHari(hari));
      if (dayStart == null || dayEnd == null || dayEnd <= dayStart) {
        return 'Format jam untuk $hari harus valid (HH:mm).';
      }
    }

    if (data.durasiSesi <= 0) {
      return 'Durasi sesi harus lebih besar dari 0.';
    }

    if (data.kelasList.isEmpty) {
      return 'Tambahkan minimal 1 kelas.';
    }

    if (data.kelasList.any((k) => k.trim().isEmpty)) {
      return 'Semua nama kelas harus terisi.';
    }

    final duplicateKelas = data.kelasList
        .map((k) => k.trim().toUpperCase())
        .toList();

    if (duplicateKelas.length != duplicateKelas.toSet().length) {
      return 'Daftar kelas mengandung duplikasi.';
    }

    if (data.jumlahRuang <= 0) {
      return 'Jumlah ruang kelas harus lebih besar dari 0.';
    }

    // Validasi istirahat per hari (karena School menyimpan istirahat per-hari)
    for (final hari in data.hariAktif) {
      for (final istirahat in data.getIstirahatForHari(hari)) {
        if (!istirahat.isValid) {
          return 'Format jam istirahat harus HH:mm dan akhir lebih besar dari mulai.';
        }
        if (istirahat.startMinutes! < start || istirahat.endMinutes! > end) {
          return 'Jam istirahat harus berada dalam jam operasional sekolah.';
        }
      }
    }

    final breakMinutes = data.hariAktif.fold<int>(0, (total, hari) {
      final normalizedBreaks = data.getNormalizedIstirahatForHari(hari);
      return total +
          normalizedBreaks.fold<int>(0, (sum, b) {
            final breakStart = b.startMinutes!;
            final breakEnd = b.endMinutes!;
            final clippedStart = breakStart < start ? start : breakStart;
            final clippedEnd = breakEnd > end ? end : breakEnd;
            if (clippedEnd <= clippedStart) return sum;
            return sum + clippedEnd - clippedStart;
          });
    });

    final totalMinutes = end - start;
    final availableMinutes = totalMinutes - breakMinutes;

    final minSessions = data.level.minSessions;
    final maxSessions = data.level.maxSessions;
    final minRequiredMinutes = minSessions * data.durasiSesi;
    final maxRequiredMinutes = maxSessions * data.durasiSesi;

    if (availableMinutes < minRequiredMinutes) {
      return 'Waktu belajar terlalu pendek setelah istirahat untuk $minSessions sesi.';
    }

    if (availableMinutes > maxRequiredMinutes + 60) {
      return 'Waktu belajar terlalu panjang setelah istirahat untuk $maxSessions sesi.';
    }

    final slots = generateTimeSlots(data);
    if (slots.isEmpty) {
      return 'Konfigurasi jam tidak valid.';
    }

    return null;
  }

  String? _validateMapel(List<Subject> data) {
    if (data.isEmpty) {
      return 'Tambahkan minimal 1 mata pelajaran.';
    }

    final maxMinutesPerWeek =
        widget.school.jumlahHari *
        widget.school.jumlahSesi *
        widget.school.durasiSesi;

    final maxJamPerMinggu = (maxMinutesPerWeek / 60).floor();

    for (int i = 0; i < data.length; i++) {
      final item = data[i];

      if (item.nama.trim().isEmpty) {
        return 'Nama mapel kosong (Mapel #${i + 1}).';
      }

      if (item.kelas.trim().isEmpty) {
        return 'Kelas kosong (Mapel #${i + 1}).';
      }

      if (item.jamPerMinggu <= 0) {
        return 'Jam per minggu harus > 0.';
      }

      if (item.jamPerMinggu > maxJamPerMinggu) {
        return 'Jam per minggu terlalu tinggi.';
      }

      if (item.guru.trim().isEmpty) {
        return 'Guru pengajar wajib diisi.';
      }

      final dupKey = '${norm(item.nama)}|${norm(item.kelas)}';

      for (int j = i + 1; j < data.length; j++) {
        final other = data[j];

        final otherKey = '${norm(other.nama)}|${norm(other.kelas)}';

        if (dupKey == otherKey) {
          return 'Mapel duplikat ditemukan.';
        }
      }
    }

    return null;
  }

  String? _validateGuru(List<Teacher> data) {
    if (data.isEmpty) {
      return 'Tambahkan minimal 1 guru.';
    }

    final maxPossibleJamPerHari =
        (widget.school.jumlahSesi * widget.school.durasiSesi) ~/ 60;

    for (final item in data) {
      if (item.nama.trim().isEmpty) {
        return 'Nama guru kosong.';
      }

      if (item.mapel.isEmpty) {
        return 'Mapel guru kosong.';
      }

      if (item.maxJamPerHari <= 0) {
        return 'Maks jam per hari harus > 0.';
      }

      if (item.maxJamPerHari > maxPossibleJamPerHari) {
        return 'Jam guru melebihi kapasitas sekolah.';
      }
    }

    return null;
  }

  String? _validateGAConfig(GAConfig data) {
    if (data.populationSize < 10) {
      return 'Population size minimal 10.';
    }

    if (data.populationSize > 500) {
      return 'Population size terlalu besar.';
    }

    if (data.mutationRate <= 0 || data.mutationRate > 1.0) {
      return 'Mutation rate tidak valid.';
    }

    if (data.crossoverRate < 0.5 || data.crossoverRate > 1.0) {
      return 'Crossover rate tidak valid.';
    }

    if (data.maxGeneration < 10) {
      return 'Max generation minimal 10.';
    }

    if (data.eliteSize <= 0) {
      return 'Elite size harus > 0.';
    }

    if (data.eliteSize >= data.populationSize) {
      return 'Elite size harus lebih kecil.';
    }

    return null;
  }

  String? _validateStep(int step) {
    switch (step) {
      case 0:
        return _validateSchool(widget.school);

      case 1:
        return _validateMapel(widget.mapel);

      case 2:
        return _validateGuru(widget.guru);

      case 3:
        return null;

      case 4:
        return _validateGAConfig(widget.gaConfig);

      default:
        return null;
    }
  }

  String? _validateAll() {
    for (int i = 0; i < 5; i++) {
      final error = _validateStep(i);

      if (error != null) return error;
    }

    final teacherByName = {
      for (final teacher in widget.guru) norm(teacher.nama): teacher,
    };

    for (final subject in widget.mapel) {
      final guruNameNorm = norm(subject.guru);
      final subjectNameNorm = norm(subject.nama);

      final teacher = teacherByName[guruNameNorm];

      if (teacher == null) {
        return 'Guru "${subject.guru}" belum terdaftar.';
      }

      final canTeach = teacher.mapel.any((m) => norm(m) == subjectNameNorm);

      if (!canTeach) {
        return 'Guru "${teacher.nama}" tidak mengajar "${subject.nama}".';
      }
    }

    return null;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.toastErrorText,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
  }

  void _handleNextStep(int targetStep) {
    if (targetStep > widget.step) {
      final error = _validateStep(widget.step);

      if (error != null) {
        _showError(error);
        return;
      }
    }

    widget.onStepChange(targetStep);
  }

  void _handleGenerate() {
    final error = _validateAll();

    if (error != null) {
      _showError(error);
      return;
    }

    widget.onGenerate();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final isMobile = screenSize.width < 768;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.heroBackground,
      body: Stack(
        children: [
          Positioned.fill(
            top: -120,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6366F1).withValues(alpha: 0.22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                    blurRadius: 140,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          // GLOW 1
          Positioned(
            top: 120,
            right: -100,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.30),
                    blurRadius: 130,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),
          // GLOW 2
          Positioned(
            bottom: -120,
            left: 80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0EA5E9).withValues(alpha: 0.14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0EA5E9).withValues(alpha: 0.22),
                    blurRadius: 120,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),

          // MAIN CONTENT
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.only(
                top: 120,
                left: isMobile ? 16 : 28,
                right: isMobile ? 16 : 28,
                bottom: 40,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      // STEP HEADER
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(isMobile ? 24 : 32),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Column(
                          children: [
                            StepIndicator(steps: steps, current: widget.step),

                            const SizedBox(height: 28),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.accentPurple,
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      stepIcons[widget.step],
                                      style: const TextStyle(fontSize: 34),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 20),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        stepTitles[widget.step],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isMobile ? 26 : 34,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: -1,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      Text(
                                        stepSubtitles[widget.step],
                                        style: TextStyle(
                                          color: AppColors.accentPurpleVeryLight
                                              .withValues(alpha: 0.85),
                                          fontSize: 15,
                                          height: 1.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // FORM CONTAINER GLASS
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(isMobile ? 22 : 36),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 40,
                                  offset: const Offset(0, 20),
                                ),
                              ],
                            ),
                            child: Theme(
                              data: ThemeData.light().copyWith(
                                scaffoldBackgroundColor: Colors.transparent,
                              ),
                              child: getStepContent(),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ACTIONS
                      Container(
                        padding: EdgeInsets.all(isMobile ? 18 : 24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: widget.step > 0
                                        ? () => widget.onStepChange(
                                            widget.step - 1,
                                          )
                                        : null,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: BorderSide(
                                        color: Colors.white.withValues(
                                          alpha: 0.14,
                                        ),
                                      ),
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.04,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: const Text(
                                      '← Kembali',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 18),

                                Expanded(
                                  flex: 2,
                                  child: widget.step < steps.length - 1
                                      ? Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                AppColors.primary,
                                                AppColors.accentPurple,
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.accentPurple
                                                    .withValues(alpha: 0.35),
                                                blurRadius: 24,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () => _handleNextStep(
                                              widget.step + 1,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 20,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                            ),
                                            child: const Text(
                                              'Lanjut →',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF059669),
                                                Color(0xFF10B981),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF10B981,
                                                ).withValues(alpha: 0.35),
                                                blurRadius: 24,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            onPressed: _handleGenerate,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 20,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                            ),
                                            child: const Text(
                                              '🚀 Generate Jadwal',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 22),

                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.center,
                              children: List.generate(steps.length, (i) {
                                final active = i == widget.step;

                                return GestureDetector(
                                  onTap: () {
                                    if (i < widget.step) {
                                      widget.onStepChange(i);
                                    } else if (i > widget.step) {
                                      final error = _validateStep(widget.step);

                                      if (error != null) {
                                        _showError(error);
                                        return;
                                      }

                                      widget.onStepChange(i);
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: active
                                          ? const LinearGradient(
                                              colors: [
                                                AppColors.primary,
                                                AppColors.accentPurple,
                                              ],
                                            )
                                          : null,
                                      color: active
                                          ? null
                                          : Colors.white.withValues(
                                              alpha: 0.04,
                                            ),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: active
                                            ? Colors.transparent
                                            : Colors.white.withValues(
                                                alpha: 0.08,
                                              ),
                                      ),
                                    ),
                                    child: Text(
                                      steps[i],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: active
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // FLOATING GLASS APPBAR
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: 90,
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
                  decoration: BoxDecoration(
                    color: AppColors.heroBackground.withValues(alpha: 0.30),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: widget.onBackToHero,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: _buildNavbarBrand(),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Text(
                            'Langkah ${widget.step + 1} dari ${steps.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavbarBrand() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [AppColors.primaryLight, AppColors.accentPurpleLight],
            ),
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),

        const SizedBox(width: 14),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'EduSchedule',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Smart Scheduling System',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
