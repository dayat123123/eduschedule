import 'dart:ui';

import 'package:flutter/material.dart';

import '../models.dart';

const List<String> hariFullList = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

class _MiniSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;

  const _MiniSectionTitle({
    required this.title,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),

        const SizedBox(width: 8),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }
}

class _GlassDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withValues(alpha: 0.10),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

/// =======================================================
/// STEP INDICATOR
/// =======================================================

class StepIndicator extends StatelessWidget {
  final List<String> steps;
  final int current;

  const StepIndicator({super.key, required this.steps, required this.current});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isSmall = screenWidth < 640;
    final bool isVerySmall = screenWidth < 430;

    final double circleSize = isVerySmall ? 38 : (isSmall ? 44 : 52);
    final double textSize = isVerySmall ? 10 : (isSmall ? 11 : 13);
    final double spacing = isVerySmall ? 8 : 12;
    final double stepWidth = isVerySmall ? 82 : (isSmall ? 102 : 122);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length, (i) {
          final bool isLast = i == steps.length - 1;
          final bool isDone = i < current;
          final bool isActive = i == current;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // STEP
              SizedBox(
                width: stepWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // CIRCLE
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeOutCubic,
                      width: circleSize,
                      height: circleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        // ACTIVE / DONE
                        gradient: isDone || isActive
                            ? const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                              )
                            : LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: 0.12),
                                  Colors.white.withValues(alpha: 0.04),
                                ],
                              ),

                        border: Border.all(
                          color: isDone || isActive
                              ? Colors.white.withValues(alpha: 0.15)
                              : Colors.white.withValues(alpha: 0.12),
                          width: 1.2,
                        ),

                        boxShadow: [
                          if (isActive)
                            BoxShadow(
                              color: const Color(
                                0xFF8B5CF6,
                              ).withValues(alpha: 0.35),
                              blurRadius: 18,
                              spreadRadius: 1,
                              offset: const Offset(0, 6),
                            ),

                          if (!isActive)
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),

                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: isDone
                              ? Icon(
                                  Icons.check_rounded,
                                  key: ValueKey('done$i'),
                                  color: Colors.white,
                                  size: isVerySmall ? 18 : 22,
                                )
                              : Text(
                                  '${i + 1}',
                                  key: ValueKey('text$i'),
                                  style: TextStyle(
                                    fontSize: isVerySmall ? 12 : 14,
                                    fontWeight: FontWeight.w800,
                                    color: isActive
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.75),
                                  ),
                                ),
                        ),
                      ),
                    ),

                    SizedBox(height: spacing),

                    // LABEL
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          height: 1.3,
                          fontSize: textSize,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isActive
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.68),
                        ),
                        child: Text(
                          steps[i],
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // CONNECTOR
              if (!isLast)
                Container(
                  margin: EdgeInsets.only(
                    top: (circleSize / 2) - 2,
                    left: isVerySmall ? 4 : 8,
                    right: isVerySmall ? 4 : 8,
                  ),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // BASE LINE
                      Container(
                        width: isVerySmall ? 28 : (isSmall ? 42 : 62),
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),

                      // ACTIVE PROGRESS
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutCubic,
                        width: isDone
                            ? (isVerySmall ? 28 : (isSmall ? 42 : 62))
                            : 0,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF8B5CF6,
                              ).withValues(alpha: 0.35),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

/// =======================================================
/// SECTION TITLE
/// =======================================================
class _SectionTitle extends StatelessWidget {
  final Color iconColor;
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFFDCE3F1),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlassField extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const _GlassField({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withValues(alpha: 0.06),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// =======================================================
/// FORM SEKOLAH
/// =======================================================

class FormSekolah extends StatefulWidget {
  final School data;
  final Function(School) onChange;

  const FormSekolah({super.key, required this.data, required this.onChange});

  @override
  State<FormSekolah> createState() => _FormSekolahState();
}

class _FormSekolahState extends State<FormSekolah> {
  final TextEditingController _kelasController = TextEditingController();

  // Temp waktu istirahat per penambahan
  String _tempBreakFrom = '';
  String _tempBreakTo = '';

  @override
  void dispose() {
    _kelasController.dispose();
    super.dispose();
  }

  int _timeToMinutes(String value) {
    final parts = value.split(':');
    if (parts.length != 2) return 0;

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    return (hour * 60) + minute;
  }

  void _addClass() {
    final value = _kelasController.text.trim();
    if (value.isEmpty) return;
    final normalized = value.toUpperCase().replaceAll(RegExp(r'\s+'), '');
    if (widget.data.kelasList.contains(normalized)) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text('Kelas "$normalized" sudah ada dalam daftar.'),
            backgroundColor: const Color(0xFFB91C1C),
          ),
        );
      return;
    }
    final newList = [...widget.data.kelasList, normalized];
    widget.onChange(
      widget.data.copyWith(kelasList: newList, kelas: newList.first),
    );
    _kelasController.clear();
  }

  // NOTE: Istirahat disimpan per-hari via data.istirahatPerHari.
  // UI penambahan istirahat per hari ada di bagian `hariAktif.map`.

  void _removeClass(String kelas) {
    final newList = widget.data.kelasList
        .where((item) => item != kelas)
        .toList();
    final newKelas = newList.isNotEmpty ? newList.first : '';
    widget.onChange(widget.data.copyWith(kelasList: newList, kelas: newKelas));
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final onChange = widget.onChange;
    return Column(
      children: [
        _CardWrapper(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.35),
                      Colors.white.withValues(alpha: 0.08),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.14),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.lightbulb, color: Colors.amber, size: 18),
                ),
              ),

              const SizedBox(width: 16),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tips Pengaturan Sekolah',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      'Atur waktu operasional sekolah dengan mudah. Sistem akan menghitung otomatis jumlah sesi pembelajaran yang optimal.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFE2E8F0),
                        fontWeight: FontWeight.w500,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ===== MAIN FORM =====
        _CardWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== HEADER =====
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.22),
                          Colors.white.withValues(alpha: 0.08),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 16),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Sekolah',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.4,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'Lengkapi data sekolah untuk mulai membuat jadwal otomatis.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFDCE3F1),
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ===== NAMA SEKOLAH =====
              Input(
                label: 'Nama Sekolah',
                value: data.nama,
                onChange: (v) => onChange(data.copyWith(nama: v)),
                helperText: 'Contoh: SMA Negeri 1 Jakarta',
              ),

              const SizedBox(height: 20),

              // ===== SCHOOL LEVEL =====
              _SectionTitle(
                iconColor: Colors.blue,
                icon: Icons.auto_awesome_rounded,
                title: 'Tingkat Sekolah',
                subtitle:
                    'Pilih jenjang pendidikan agar konfigurasi default otomatis disesuaikan.',
              ),

              const SizedBox(height: 14),

              _GlassField(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: DropdownButton<SchoolLevel>(
                  value: data.level,
                  isExpanded: true,
                  underline: const SizedBox(),
                  borderRadius: BorderRadius.circular(18),
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  items: SchoolLevel.values.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text('${level.code} - ${level.name}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onChange(
                        data.copyWith(
                          level: value,
                          kelas: value.defaultClasses(count: 3).first,
                          kelasList: value.defaultClasses(count: 3),
                          jamMulai: value.defaultStartTime,
                          jamSelesai: value.defaultEndTime,
                          durasiSesi: value.defaultSessionDuration,
                          jumlahSesi: value.typicalSessionsPerDay,
                          // Istirahat disimpan per-hari
                          istirahatPerHari: {},
                          jumlahRuang: value.defaultClassrooms,
                        ),
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 28),

              // ===== KELAS =====
              _SectionTitle(
                iconColor: const Color(0xFF34D399),
                icon: Icons.groups_rounded,
                title: 'Daftar Kelas',
                subtitle:
                    'Tambahkan semua kelas yang akan dimasukkan ke jadwal.',
              ),

              const SizedBox(height: 16),

              if (data.kelasList.isNotEmpty)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: data.kelasList.map((kelas) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),

                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                            ),

                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.12),
                                Colors.white.withValues(alpha: 0.03),
                              ],
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                kelas,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),

                              const SizedBox(width: 10),

                              InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () => _removeClass(kelas),
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.08),
                                  ),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white70,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white.withValues(alpha: 0.05),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white54,
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Belum ada kelas ditambahkan.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 18),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 620;

                  final inputField = Expanded(
                    child: Input(
                      label: 'Tambah Kelas',
                      value: _kelasController.text,
                      onChange: (v) {
                        _kelasController.text = v;
                        _kelasController.selection = TextSelection.collapsed(
                          offset: v.length,
                        );
                      },
                      helperText: 'Contoh: 10-A, 7-B, 1-C',
                    ),
                  );

                  final addButton = SizedBox(
                    height: 58,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF8B5CF6,
                            ).withValues(alpha: 0.25),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _addClass,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Tambah',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  );

                  if (isMobile) {
                    return Column(
                      children: [
                        Row(children: [inputField]),
                        const SizedBox(height: 14),
                        SizedBox(width: double.infinity, child: addButton),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      inputField,
                      const SizedBox(width: 14),
                      addButton,
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // ===== HARI AKTIF =====
              _SectionTitle(
                iconColor: const Color(0xFF7DD3FC),
                icon: Icons.calendar_month_rounded,
                title: 'Hari Aktif Sekolah',
                subtitle: 'Pilih hari operasional sekolah setiap minggu.',
              ),

              const SizedBox(height: 14),

              MultiSelect(
                label: 'Hari Aktif Sekolah',
                options: hariFullList,
                selected: data.hariAktif,
                onChange: (v) {
                  onChange(data.copyWith(hariAktif: v, jumlahHari: v.length));
                },
              ),

              const SizedBox(height: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white.withValues(alpha: 0.08),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Text(
                      '📅 ${data.hariAktif.length} hari per minggu',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              if (data.hariAktif.isNotEmpty) ...[
                const SizedBox(height: 28),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jam Operasional Per Hari',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Atur jam mulai dan berakhir untuk setiap hari (opsional, gunakan default jika kosong).',
                      style: TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...data.hariAktif.map((hari) {
                  final dayStart = data.jamMulaiPerHari[hari] ?? data.jamMulai;
                  final dayEnd =
                      data.jamSelesaiPerHari[hari] ?? data.jamSelesai;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white.withValues(alpha: 0.05),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Text(
                                hari,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (data.hariAktif.isEmpty) return;

                                  final firstDay = data.hariAktif.first;
                                  final start =
                                      data.jamMulaiPerHari[firstDay] ??
                                      data.jamMulai;
                                  final end =
                                      data.jamSelesaiPerHari[firstDay] ??
                                      data.jamSelesai;

                                  final newStartMap = <String, String>{};
                                  final newEndMap = <String, String>{};

                                  for (final h in data.hariAktif) {
                                    newStartMap[h] = start;
                                    newEndMap[h] = end;
                                  }

                                  onChange(
                                    data.copyWith(
                                      jamMulaiPerHari: newStartMap,
                                      jamSelesaiPerHari: newEndMap,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                    ..clearSnackBars()
                                    ..showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Jam operasional berhasil dicopy ke semua hari',
                                        ),
                                        backgroundColor: Color(0xFF059669),
                                      ),
                                    );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white.withValues(alpha: 0.08),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.08,
                                      ),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.copy_all_rounded,
                                        size: 14,
                                        color: Colors.white70,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Salin ke Semua Hari',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    final now = TimeOfDay.now();
                                    TimeOfDay initialTime = now;
                                    final parts = dayStart.split(':');
                                    if (parts.length == 2) {
                                      initialTime = TimeOfDay(
                                        hour:
                                            int.tryParse(parts[0]) ?? now.hour,
                                        minute:
                                            int.tryParse(parts[1]) ??
                                            now.minute,
                                      );
                                    }
                                    final picked = await showTimePicker(
                                      context: context,
                                      initialTime: initialTime,
                                    );
                                    if (picked != null) {
                                      final formattedTime =
                                          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                                      final newMap = {...data.jamMulaiPerHari};
                                      if (formattedTime == data.jamMulai) {
                                        newMap.remove(hari);
                                      } else {
                                        newMap[hari] = formattedTime;
                                      }
                                      onChange(
                                        data.copyWith(jamMulaiPerHari: newMap),
                                      );
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: Input(
                                      label: 'Jam Mulai',
                                      value: dayStart,
                                      onChange: (_) {},
                                      helperText: 'Pilih jam mulai',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    final now = TimeOfDay.now();
                                    TimeOfDay initialTime = now;
                                    final parts = dayEnd.split(':');
                                    if (parts.length == 2) {
                                      initialTime = TimeOfDay(
                                        hour:
                                            int.tryParse(parts[0]) ?? now.hour,
                                        minute:
                                            int.tryParse(parts[1]) ??
                                            now.minute,
                                      );
                                    }
                                    final picked = await showTimePicker(
                                      context: context,
                                      initialTime: initialTime,
                                    );
                                    if (picked != null) {
                                      final formattedTime =
                                          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                                      final newMap = {
                                        ...data.jamSelesaiPerHari,
                                      };
                                      if (formattedTime == data.jamSelesai) {
                                        newMap.remove(hari);
                                      } else {
                                        newMap[hari] = formattedTime;
                                      }
                                      onChange(
                                        data.copyWith(
                                          jamSelesaiPerHari: newMap,
                                        ),
                                      );
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: Input(
                                      label: 'Jam Selesai',
                                      value: dayEnd,
                                      onChange: (_) {},
                                      helperText: 'Pilih jam selesai',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Jam Istirahat',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  final currentBreaks = List<SchoolBreak>.from(
                                    data.istirahatPerHari[hari] ?? [],
                                  );

                                  if (currentBreaks.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                      ..clearSnackBars()
                                      ..showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Belum ada jam istirahat untuk disalin.',
                                          ),
                                          backgroundColor: Color(0xFFB91C1C),
                                        ),
                                      );
                                    return;
                                  }

                                  final newMap = <String, List<SchoolBreak>>{
                                    ...data.istirahatPerHari,
                                  };

                                  for (final h in data.hariAktif) {
                                    newMap[h] = currentBreaks
                                        .map(
                                          (e) => SchoolBreak(
                                            dari: e.dari,
                                            sampai: e.sampai,
                                          ),
                                        )
                                        .toList();
                                  }

                                  onChange(
                                    data.copyWith(istirahatPerHari: newMap),
                                  );

                                  ScaffoldMessenger.of(context)
                                    ..clearSnackBars()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Jam istirahat hari $hari berhasil disalin ke semua hari.',
                                        ),
                                        backgroundColor: const Color(
                                          0xFF059669,
                                        ),
                                      ),
                                    );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white.withValues(alpha: 0.08),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.08,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.copy_all_rounded,
                                        size: 14,
                                        color: Colors.white70,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Salin ke Semua Hari',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if ((data.istirahatPerHari[hari] ?? []).isNotEmpty)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: (data.istirahatPerHari[hari] ?? []).map(
                                (breakTime) {
                                  return InputChip(
                                    label: Text(
                                      '${breakTime.dari} - ${breakTime.sampai}',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    onDeleted: () {
                                      final newMap = {...data.istirahatPerHari};
                                      newMap[hari] = (newMap[hari] ?? [])
                                          .where(
                                            (b) =>
                                                !(b.dari == breakTime.dari &&
                                                    b.sampai ==
                                                        breakTime.sampai),
                                          )
                                          .toList();
                                      if (newMap[hari]!.isEmpty) {
                                        newMap.remove(hari);
                                      }
                                      onChange(
                                        data.copyWith(istirahatPerHari: newMap),
                                      );
                                    },
                                  );
                                },
                              ).toList(),
                            )
                          else
                            Text(
                              'Belum ada istirahat',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white30,
                              ),
                            ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    final now = TimeOfDay.now();
                                    TimeOfDay initialTime = now;
                                    final picked = await showTimePicker(
                                      context: context,
                                      initialTime: initialTime,
                                    );
                                    if (picked != null) {
                                      final formattedTime =
                                          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                                      // Store in a temp controller or state
                                      if (!mounted) return;
                                      setState(() {
                                        _tempBreakFrom = formattedTime;
                                      });
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: Input(
                                      label: 'Istirahat dari',
                                      value: _tempBreakFrom,
                                      onChange: (_) {},
                                      helperText: 'Pilih jam',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    final now = TimeOfDay.now();
                                    TimeOfDay initialTime = now;
                                    final picked = await showTimePicker(
                                      context: context,
                                      initialTime: initialTime,
                                    );
                                    if (picked != null) {
                                      final formattedTime =
                                          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                                      if (!mounted) return;
                                      setState(() {
                                        _tempBreakTo = formattedTime;
                                      });
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: Input(
                                      label: 'sampai',
                                      value: _tempBreakTo,
                                      onChange: (_) {},
                                      helperText: 'Pilih jam',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 44,
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_tempBreakFrom.isEmpty ||
                                        _tempBreakTo.isEmpty) {
                                      return;
                                    }

                                    final newBreak = SchoolBreak(
                                      dari: _tempBreakFrom,
                                      sampai: _tempBreakTo,
                                    );

                                    if (!newBreak.isValid) {
                                      ScaffoldMessenger.of(context)
                                        ..clearSnackBars()
                                        ..showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Jam istirahat tidak valid.',
                                            ),
                                            backgroundColor: Color(0xFFB91C1C),
                                          ),
                                        );
                                      return;
                                    }

                                    final schoolStart =
                                        data.jamMulaiPerHari[hari] ??
                                        data.jamMulai;

                                    final schoolEnd =
                                        data.jamSelesaiPerHari[hari] ??
                                        data.jamSelesai;

                                    final schoolStartMin = _timeToMinutes(
                                      schoolStart,
                                    );
                                    final schoolEndMin = _timeToMinutes(
                                      schoolEnd,
                                    );

                                    final breakStartMin =
                                        newBreak.startMinutes!;
                                    final breakEndMin = newBreak.endMinutes!;

                                    // VALIDASI:
                                    // Istirahat harus berada di dalam jam sekolah
                                    if (breakStartMin < schoolStartMin ||
                                        breakEndMin > schoolEndMin) {
                                      ScaffoldMessenger.of(context)
                                        ..clearSnackBars()
                                        ..showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Jam istirahat harus berada di antara '
                                              '$schoolStart - $schoolEnd',
                                            ),
                                            backgroundColor: const Color(
                                              0xFFB91C1C,
                                            ),
                                          ),
                                        );
                                      return;
                                    }

                                    final existingBreaks =
                                        data.istirahatPerHari[hari] ?? [];

                                    // VALIDASI TIDAK BOLEH TABRAKAN
                                    for (final item in existingBreaks) {
                                      final existingStart = item.startMinutes!;
                                      final existingEnd = item.endMinutes!;

                                      final isOverlap =
                                          breakStartMin < existingEnd &&
                                          breakEndMin > existingStart;

                                      if (isOverlap) {
                                        ScaffoldMessenger.of(context)
                                          ..clearSnackBars()
                                          ..showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Jam istirahat bertabrakan dengan istirahat lain.',
                                              ),
                                              backgroundColor: Color(
                                                0xFFB91C1C,
                                              ),
                                            ),
                                          );
                                        return;
                                      }
                                    }

                                    final newMap = {...data.istirahatPerHari};

                                    newMap[hari] = [
                                      ...existingBreaks,
                                      newBreak,
                                    ];

                                    onChange(
                                      data.copyWith(istirahatPerHari: newMap),
                                    );

                                    setState(() {
                                      _tempBreakFrom = '';
                                      _tempBreakTo = '';
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.2,
                                    ),
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// =======================================================
/// FORM MAPEL
/// =======================================================

class FormMapel extends StatefulWidget {
  final List<Subject> data;
  final Function(List<Subject>) onChange;
  final School school;

  const FormMapel({
    super.key,
    required this.data,
    required this.onChange,
    required this.school,
  });

  @override
  State<FormMapel> createState() => _FormMapelState();
}

class _FormMapelState extends State<FormMapel> {
  void add() {
    final newData = List<Subject>.from(widget.data)
      ..add(
        Subject(
          id: UniqueKey().hashCode,
          nama: '',
          kelas: widget.school.availableGrades.isNotEmpty
              ? widget.school.availableGrades.first
              : '1-A',
          jamPerMinggu: 2,
          guru: '',
          durasiPerSesi: widget.school.level.defaultSessionDuration,
        ),
      );

    widget.onChange(newData);
  }

  void remove(int id) {
    widget.onChange(widget.data.where((x) => x.id != id).toList());
  }

  void update(int id, String key, dynamic val) {
    widget.onChange(
      widget.data.map((x) {
        if (x.id == id) {
          switch (key) {
            case 'nama':
              return x.copyWith(nama: val);

            case 'kelas':
              return x.copyWith(kelas: val);

            case 'jamPerMinggu':
              return x.copyWith(jamPerMinggu: val);

            case 'durasiPerSesi':
              return x.copyWith(durasiPerSesi: val);
          }
        }

        return x;
      }).toList(),
    );
  }

  void copyDurationToAll(int sourceDuration) {
    widget.onChange(
      widget.data
          .map((x) => x.copyWith(durasiPerSesi: sourceDuration))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Info badge showing current progress
        if (widget.data.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFEEF2FF),
              ),
              child: Text(
                '📚 ${widget.data.length} mata pelajaran ditambahkan',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4338CA),
                ),
              ),
            ),
          ),
        if (widget.data.isNotEmpty) const SizedBox(height: 14),
        ...widget.data.asMap().entries.map((entry) {
          final index = entry.key;
          final m = entry.value;

          return _CardWrapper(
            key: ValueKey(m.id),
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: .center,
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            'Mata Pelajaran #${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Atur kelas dan alokasi waktu pelajaran.',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _DeleteButton(onTap: () => remove(m.id)),
                  ],
                ),

                LayoutBuilder(
                  builder: (context, c) {
                    final isMobile = c.maxWidth < 720;

                    final kelasField = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 2, bottom: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.layers_rounded,
                                size: 16,
                                color: Colors.white70,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Kelas',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        _GlassField(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: DropdownButton<String>(
                            value:
                                widget.school.availableGrades.contains(m.kelas)
                                ? m.kelas
                                : widget.school.availableGrades.isNotEmpty
                                ? widget.school.availableGrades.first
                                : m.kelas,
                            isExpanded: true,
                            underline: const SizedBox(),
                            borderRadius: BorderRadius.circular(20),
                            dropdownColor: const Color(0xFF111827),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.white70,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            items: widget.school.availableGrades.map((grade) {
                              return DropdownMenuItem(
                                value: grade,
                                child: Text(
                                  grade,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                update(m.id, 'kelas', value);
                              }
                            },
                          ),
                        ),
                      ],
                    );

                    final jamField = Input(
                      label: 'Jam / Minggu',
                      value: m.jamPerMinggu.toString(),
                      type: TextInputType.number,
                      onChange: (v) {
                        final value = int.tryParse(v);

                        if (value != null) {
                          update(m.id, 'jamPerMinggu', value);
                        }
                      },
                      helperText: 'Rekomendasi 2–6 jam per minggu',
                    );

                    final durasiField = Input(
                      label: 'Durasi / Sesi (menit)',
                      value: m.durasiPerSesi.toString(),
                      type: TextInputType.number,
                      onChange: (v) {
                        final value = int.tryParse(v);

                        if (value != null) {
                          update(m.id, 'durasiPerSesi', value);
                        }
                      },
                      helperText: 'Durasi dalam menit per sesi pembelajaran',
                    );

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withValues(alpha: 0.10),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),

                        // ===== CONTENT =====
                        Input(
                          label: 'Nama Mapel',
                          value: m.nama,
                          onChange: (v) => update(m.id, 'nama', v),
                          helperText: 'Contoh: Matematika, Bahasa Indonesia',
                        ),

                        const SizedBox(height: 18),

                        if (isMobile) ...[
                          kelasField,

                          const SizedBox(height: 18),

                          jamField,

                          const SizedBox(height: 18),

                          durasiField,

                          const SizedBox(height: 14),

                          // Copy button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  copyDurationToAll(m.durasiPerSesi),
                              icon: const Icon(Icons.content_copy_rounded),
                              label: const Text(
                                'Salin durasi ke semua',
                                style: TextStyle(color: Colors.white70),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white70,
                                side: const BorderSide(color: Colors.white30),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 2, child: kelasField),

                              const SizedBox(width: 16),

                              Expanded(child: jamField),

                              const SizedBox(width: 16),

                              Expanded(child: durasiField),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Copy button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  copyDurationToAll(m.durasiPerSesi),
                              icon: const Icon(Icons.content_copy_rounded),
                              label: const Text(
                                'Salin durasi ke semua',
                                style: TextStyle(color: Colors.white70),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white70,
                                side: const BorderSide(color: Colors.white30),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        }),

        _AddButton(
          label: 'Tambah Mata Pelajaran',
          color: const Color(0xFF6366F1),
          onTap: add,
        ),
      ],
    );
  }
}

/// =======================================================
/// SHARED COMPONENTS
/// =======================================================
class _CardWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;

  const _CardWrapper({super.key, required this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          margin: margin,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),

            // ❌ HAPUS background putih solid
            color: Colors.white.withValues(alpha: 0.12),

            // ✨ liquid glass border
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.22),
              width: 1.2,
            ),

            // ✨ glow lembut
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(-4, -4),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 28,
                offset: const Offset(0, 18),
              ),
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.06),
                blurRadius: 30,
                spreadRadius: 2,
                offset: const Offset(0, 12),
              ),
            ],

            // ✨ subtle gradient glass
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.18),
                Colors.white.withValues(alpha: 0.08),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback onTap;

  const _DeleteButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Color(0xFFBE123C),
        ),
      ),
    );
  }
}

class Input extends StatefulWidget {
  final String label;
  final String value;
  final Function(String) onChange;
  final TextInputType type;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? helperText;

  const Input({
    super.key,
    required this.label,
    required this.value,
    required this.onChange,
    this.type = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.helperText,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant Input oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != _controller.text) {
      _controller.text = widget.value;

      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: _controller,
          onChanged: widget.onChange,
          keyboardType: widget.type,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            fillColor: Colors.white.withValues(alpha: 0.06),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
            helperText: widget.helperText,
            helperStyle: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9CA3AF),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class MultiSelect extends StatelessWidget {
  final String label;
  final List<String> options;
  final List<String> selected;
  final Function(List<String>) onChange;

  const MultiSelect({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final selectedItem = selected.contains(opt);

            return InkWell(
              onTap: () {
                final newList = List<String>.from(selected);

                if (selectedItem) {
                  newList.remove(opt);
                } else {
                  newList.add(opt);
                }

                onChange(newList);
              },
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: selectedItem
                      ? const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        )
                      : null,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.10),
                  ),
                  color: selectedItem
                      ? null
                      : Colors.white.withValues(alpha: 0.10),
                ),
                child: Text(
                  opt,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: selectedItem
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _AddButton({
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.12),
              color.withValues(alpha: 0.06),
            ],
          ),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: color),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToggleCard extends StatelessWidget {
  final bool checked;
  final String label;
  final Function(bool) onChange;

  const ToggleCard({
    super.key,
    required this.checked,
    required this.label,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChange(!checked),
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),

            // ===== LIQUID GLASS =====
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: checked
                  ? [
                      const Color(0xFF6366F1).withValues(alpha: 0.20),
                      const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.07),
                      Colors.white.withValues(alpha: 0.03),
                    ],
            ),

            border: Border.all(
              color: checked
                  ? const Color(0xFF8B5CF6).withValues(alpha: 0.45)
                  : Colors.white.withValues(alpha: 0.08),
              width: 1.2,
            ),

            boxShadow: [
              if (checked)
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.18),
                  blurRadius: 18,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
            ],
          ),

          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: checked
                      ? const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        )
                      : null,
                  color: checked ? null : Colors.white.withValues(alpha: 0.06),
                  border: Border.all(
                    color: checked
                        ? Colors.transparent
                        : Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: Icon(
                  checked ? Icons.check_rounded : Icons.circle_outlined,
                  color: checked ? Colors.white : Colors.white38,
                  size: checked ? 15 : 12,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.3,
                    fontWeight: checked ? FontWeight.w700 : FontWeight.w500,
                    color: checked
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.72),
                    letterSpacing: 0.1,
                  ),
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliderCard extends StatelessWidget {
  final String label;
  final double value;
  final double min, max;
  final Function(double) onChange;

  const SliderCard({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        // ===== GLASS SURFACE =====
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.03),
          ],
        ),

        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER =====
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.90),
                    letterSpacing: 0.2,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6366F1).withValues(alpha: 0.28),
                      const Color(0xFF8B5CF6).withValues(alpha: 0.18),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ===== SLIDER =====
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 5,
              activeTrackColor: const Color(0xFF8B5CF6),
              inactiveTrackColor: Colors.white.withValues(alpha: 0.08),

              thumbColor: Colors.white,
              overlayColor: const Color(0xFF8B5CF6).withValues(alpha: 0.14),

              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),

              overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: (max - min).toInt(),
              onChanged: onChange,
            ),
          ),

          const SizedBox(height: 6),

          // ===== RANGE INFO =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                min.toInt().toString(),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.45),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                max.toInt().toString(),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.45),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- FORM GURU ---
class FormGuru extends StatefulWidget {
  final List<Teacher> data;
  final Function(List<Teacher>) onChange;
  final List<String> subjectOptions;
  final List<String> hariOptions;

  const FormGuru({
    super.key,
    required this.data,
    required this.onChange,
    required this.subjectOptions,
    required this.hariOptions,
  });

  @override
  State<FormGuru> createState() => _FormGuruState();
}

class _FormGuruState extends State<FormGuru> {
  void add() {
    final newData = List<Teacher>.from(widget.data)
      ..add(
        Teacher(
          id: DateTime.now().microsecondsSinceEpoch,
          nama: '',
          mapel: [],
          maxJamPerHari: 4,
          // Default untuk memudahkan guru: semua hari dianggap preferensi,
          // dan hari tidak bisa default kosong.
          preferensiHari: widget.hariOptions,
          hariTidakBisa: [],
        ),
      );
    widget.onChange(newData);
  }

  void remove(int id) {
    widget.onChange(widget.data.where((x) => x.id != id).toList());
  }

  void update(int id, String key, dynamic val) {
    widget.onChange(
      widget.data.map((x) {
        if (x.id == id) {
          switch (key) {
            case 'nama':
              return x.copyWith(nama: val);
            case 'mapel':
              return x.copyWith(mapel: val);
            case 'maxJamPerHari':
              return x.copyWith(maxJamPerHari: val);
            case 'preferensiHari':
              return x.copyWith(preferensiHari: val);
            case 'hariTidakBisa':
              return x.copyWith(hariTidakBisa: val);
          }
        }
        return x;
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Info badge showing current progress
        if (widget.data.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFE0F2FE),
              ),
              child: Text(
                '👨‍🏫 ${widget.data.length} guru terdaftar',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0369A1),
                ),
              ),
            ),
          ),
        if (widget.data.isNotEmpty) const SizedBox(height: 12),
        ...widget.data.map((g) {
          return _CardWrapper(
            key: ValueKey(g.id),
            margin: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== HEADER =====
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.18),
                            Colors.white.withValues(alpha: 0.06),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.10),
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.blue,
                        size: 22,
                      ),
                    ),

                    const SizedBox(width: 14),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Pengajar',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                          ),

                          SizedBox(height: 3),

                          Text(
                            'Atur informasi guru dan preferensi mengajar.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFDCE3F1),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    _DeleteButton(onTap: () => remove(g.id)),
                  ],
                ),

                const SizedBox(height: 22),

                // ===== PEMISAH =====
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ===== BASIC INFO =====
                _MiniSectionTitle(
                  title: 'Informasi Dasar',
                  icon: Icons.badge_rounded,
                  iconColor: Colors.blue,
                ),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 650;

                    final namaField = Expanded(
                      child: Input(
                        label: 'Nama Guru',
                        value: g.nama,
                        onChange: (v) => update(g.id, 'nama', v),
                        helperText: 'Nama lengkap pendidik',
                      ),
                    );

                    final jamField = Expanded(
                      child: Input(
                        label: 'Maks Jam/Hari',
                        value: g.maxJamPerHari.toString(),
                        type: TextInputType.number,
                        onChange: (v) =>
                            update(g.id, 'maxJamPerHari', int.tryParse(v) ?? 4),
                        helperText: 'Batas maksimal jam mengajar',
                      ),
                    );

                    if (isMobile) {
                      return Column(
                        children: [
                          Row(children: [namaField]),
                          const SizedBox(height: 14),
                          Row(children: [jamField]),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        namaField,
                        const SizedBox(width: 14),
                        jamField,
                      ],
                    );
                  },
                ),

                const SizedBox(height: 22),
                // ===== DIVIDER =====
                _GlassDivider(),

                const SizedBox(height: 22),

                // ===== SUBJECT =====
                _MiniSectionTitle(
                  title: 'Mata Pelajaran',
                  icon: Icons.menu_book_rounded,
                  iconColor: Color(0xFF38BDF8),
                ),

                const SizedBox(height: 14),

                MultiSelect(
                  label: 'Mata Pelajaran yang Diajar',
                  options: widget.subjectOptions,
                  selected: g.mapel,
                  onChange: (v) => update(g.id, 'mapel', v),
                ),

                const SizedBox(height: 26),

                // ===== DIVIDER =====
                _GlassDivider(),

                const SizedBox(height: 22),

                // ===== AVAILABILITY =====
                _MiniSectionTitle(
                  title: 'Ketersediaan Mengajar',
                  icon: Icons.calendar_month_rounded,
                  iconColor: Color(0xFF38BDF8),
                ),

                const SizedBox(height: 14),

                MultiSelect(
                  label: 'Hari Tidak Bisa Mengajar',
                  options: hariFullList,
                  selected: g.hariTidakBisa,
                  onChange: (v) => update(g.id, 'hariTidakBisa', v),
                ),
              ],
            ),
          );
        }),
        _AddButton(
          label: 'Tambah Guru',
          onTap: add,
          color: const Color(0xFF10B981),
        ),
      ],
    );
  }
}

// --- FORM CONSTRAINTS & CONFIG ---
class FormConstraints extends StatelessWidget {
  final Constraints data;
  final Function(Constraints) onChange;

  const FormConstraints({
    super.key,
    required this.data,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: isMobile ? (constraints.maxWidth - 12) / 2 : 220,
                  child: ToggleCard(
                    checked: data.guruTidakBentrok,
                    onChange: (v) =>
                        onChange(data.copyWith(guruTidakBentrok: v)),
                    label: 'Guru No Bentrok',
                  ),
                ),

                SizedBox(
                  width: isMobile ? (constraints.maxWidth - 12) / 2 : 220,
                  child: ToggleCard(
                    checked: data.kelasTidakBentrok,
                    onChange: (v) =>
                        onChange(data.copyWith(kelasTidakBentrok: v)),
                    label: 'Kelas No Bentrok',
                  ),
                ),

                SizedBox(
                  width: isMobile ? (constraints.maxWidth - 12) / 2 : 220,
                  child: ToggleCard(
                    checked: data.ruangTidakBentrok,
                    onChange: (v) =>
                        onChange(data.copyWith(ruangTidakBentrok: v)),
                    label: 'Ruang No Bentrok',
                  ),
                ),

                SizedBox(
                  width: isMobile ? (constraints.maxWidth - 12) / 2 : 220,
                  child: ToggleCard(
                    checked: data.hindariJamKosong,
                    onChange: (v) =>
                        onChange(data.copyWith(hindariJamKosong: v)),
                    label: 'Minim Jam Kosong',
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        SliderCard(
          label: 'Maks Pelajaran Berat / Hari',
          value: data.maxBeratPerHari.toDouble(),
          min: 1,
          max: 5,
          onChange: (v) => onChange(data.copyWith(maxBeratPerHari: v.toInt())),
        ),
        const SizedBox(height: 12),
        SliderCard(
          label: 'Maks Pelajaran Berturut-turut',
          value: data.maxBerturutan.toDouble(),
          min: 1,
          max: 6,
          onChange: (v) => onChange(data.copyWith(maxBerturutan: v.toInt())),
        ),
      ],
    );
  }
}

class FormGAConfig extends StatefulWidget {
  final GAConfig data;
  final Function(GAConfig) onChange;

  const FormGAConfig({super.key, required this.data, required this.onChange});

  @override
  State<FormGAConfig> createState() => _FormGAConfigState();
}

class _FormGAConfigState extends State<FormGAConfig> {
  final Map<String, String> tooltips = {
    'populationSize': 'Jumlah individu dalam satu generasi.',
    'mutationRate': 'Probabilitas perubahan acak.',
    'crossoverRate': 'Probabilitas penggabungan solusi.',
    'maxGeneration': 'Batas iterasi evolusi.',
    'eliteSize': 'Solusi terbaik yang dipertahankan.',
  };

  String? activeTooltip;

  @override
  Widget build(BuildContext context) {
    final fields = [
      {
        'key': 'populationSize',
        'label': 'Populasi',
        'icon': Icons.groups_rounded,
        'min': 10,
        'max': 200,
      },
      {
        'key': 'mutationRate',
        'label': 'Mutasi',
        'icon': Icons.auto_fix_high_rounded,
        'min': 0.01,
        'max': 0.5,
      },
      {
        'key': 'crossoverRate',
        'label': 'Crossover',
        'icon': Icons.merge_type_rounded,
        'min': 0.5,
        'max': 1.0,
      },
      {
        'key': 'maxGeneration',
        'label': 'Generasi',
        'icon': Icons.timeline_rounded,
        'min': 50,
        'max': 500,
      },
      {
        'key': 'eliteSize',
        'label': 'Elitisme',
        'icon': Icons.workspace_premium_rounded,
        'min': 1,
        'max': 20,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: fields.map((f) {
            final key = f['key'] as String;

            double val;
            switch (key) {
              case 'populationSize':
                val = widget.data.populationSize.toDouble();
                break;
              case 'mutationRate':
                val = widget.data.mutationRate;
                break;
              case 'crossoverRate':
                val = widget.data.crossoverRate;
                break;
              case 'maxGeneration':
                val = widget.data.maxGeneration.toDouble();
                break;
              case 'eliteSize':
                val = widget.data.eliteSize.toDouble();
                break;
              default:
                val = 0;
            }

            return SizedBox(
              width: isMobile ? constraints.maxWidth : 260,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),

                  // ===== LIQUID GLASS =====
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.07),
                      Colors.white.withValues(alpha: 0.03),
                    ],
                  ),

                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== TOP =====
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF6366F1).withValues(alpha: 0.90),
                                const Color(0xFF8B5CF6).withValues(alpha: 0.85),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF8B5CF6,
                                ).withValues(alpha: 0.25),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            f['icon'] as IconData,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f['label'] as String,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                activeTooltip == key
                                    ? tooltips[key]!
                                    : 'Konfigurasi algoritma',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  height: 1.4,
                                  color: Colors.white.withValues(alpha: 0.55),
                                ),
                              ),
                            ],
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              activeTooltip = activeTooltip == key ? null : key;
                            });
                          },
                          child: Icon(
                            activeTooltip == key
                                ? Icons.close_rounded
                                : Icons.info_outline_rounded,
                            size: 18,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // ===== VALUE =====
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          val.toStringAsFixed(key.contains('Rate') ? 2 : 0),
                          style: const TextStyle(
                            fontSize: 28,
                            height: 1,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            key.contains('Rate') ? '%' : '',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // ===== SLIDER =====
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        activeTrackColor: const Color(0xFF8B5CF6),
                        inactiveTrackColor: Colors.white.withValues(
                          alpha: 0.08,
                        ),

                        thumbColor: Colors.white,

                        overlayColor: const Color(
                          0xFF8B5CF6,
                        ).withValues(alpha: 0.12),

                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 7,
                        ),
                      ),

                      child: Slider(
                        value: val,
                        min: (f['min'] as num).toDouble(),
                        max: (f['max'] as num).toDouble(),
                        onChanged: (v) {
                          GAConfig n;

                          switch (key) {
                            case 'populationSize':
                              n = widget.data.copyWith(
                                populationSize: v.toInt(),
                              );
                              break;

                            case 'mutationRate':
                              n = widget.data.copyWith(mutationRate: v);
                              break;

                            case 'crossoverRate':
                              n = widget.data.copyWith(crossoverRate: v);
                              break;

                            case 'maxGeneration':
                              n = widget.data.copyWith(
                                maxGeneration: v.toInt(),
                              );
                              break;

                            case 'eliteSize':
                              n = widget.data.copyWith(eliteSize: v.toInt());
                              break;

                            default:
                              n = widget.data;
                          }

                          widget.onChange(n);
                        },
                      ),
                    ),

                    const SizedBox(height: 4),

                    // ===== RANGE =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${f['min']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.40),
                          ),
                        ),
                        Text(
                          '${f['max']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.40),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
