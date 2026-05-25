import 'dart:ui';

import 'package:excel/excel.dart' as ex;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

import '../models.dart';
import '../theme.dart';

class ResultScreen extends StatefulWidget {
  final List<Gene>? schedule;
  final School school;
  final List<FitnessHistory> fitnessHistory;
  final VoidCallback onEdit;
  final VoidCallback onTapBack;

  const ResultScreen({
    super.key,
    required this.schedule,
    required this.school,
    required this.fitnessHistory,
    required this.onEdit,
    required this.onTapBack,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ScrollController _scrollController = ScrollController();
  String filterKelas = "Semua";
  String filterGuru = "Semua";
  String filterHari = "Semua";

  Future<void> _onDownload(List<Gene> schedule) async {
    try {
      final excel = ex.Excel.createExcel();

      /// HAPUS SHEET DEFAULT
      final defaultSheet = excel.getDefaultSheet();

      /// BUAT SHEET JADWAL
      final ex.Sheet sheet = excel['Jadwal'];

      /// SET DEFAULT
      excel.setDefaultSheet('Jadwal');

      /// DELETE SHEET LAMA
      if (defaultSheet != null && defaultSheet != 'Jadwal') {
        excel.delete(defaultSheet);
      }

      /// SORT DATA
      final sortedSchedule = [...schedule];

      final hariOrder = {
        'Senin': 1,
        'Selasa': 2,
        'Rabu': 3,
        'Kamis': 4,
        'Jumat': 5,
        'Sabtu': 6,
        'Minggu': 7,
      };

      sortedSchedule.sort((a, b) {
        /// SORT HARI
        final hariCompare = (hariOrder[a.hari] ?? 999).compareTo(
          hariOrder[b.hari] ?? 999,
        );

        if (hariCompare != 0) {
          return hariCompare;
        }

        /// SORT SLOT/JAM
        return a.slot.compareTo(b.slot);
      });

      /// HEADER
      final headers = [
        'Hari',
        'Slot',
        'Mata Pelajaran',
        'Kelas',
        'Guru',
        'Ruangan',
      ];

      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.cell(
          ex.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
        );

        cell.value = ex.TextCellValue(headers[i]);

        cell.cellStyle = ex.CellStyle(
          bold: true,
          horizontalAlign: ex.HorizontalAlign.Center,
        );
      }

      /// DATA
      for (int i = 0; i < sortedSchedule.length; i++) {
        final item = sortedSchedule[i];

        final row = i + 1;

        sheet
            .cell(ex.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
            .value = ex.TextCellValue(
          item.hari,
        );

        sheet
            .cell(ex.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
            .value = ex.TextCellValue(
          item.slot,
        );

        sheet
            .cell(ex.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
            .value = ex.TextCellValue(
          item.mapelNama,
        );

        sheet
            .cell(ex.CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
            .value = ex.TextCellValue(
          item.kelas,
        );

        sheet
            .cell(ex.CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
            .value = ex.TextCellValue(
          item.guru,
        );

        sheet
            .cell(ex.CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
            .value = ex.TextCellValue(
          item.ruang.toString(),
        );
      }

      /// AUTO WIDTH
      for (int i = 0; i < headers.length; i++) {
        sheet.setColumnWidth(i, 24);
      }

      final bytes = excel.encode();

      if (bytes == null) {
        throw Exception('Gagal generate excel');
      }

      final dir = await getApplicationDocumentsDirectory();

      final file = File('${dir.path}/jadwal_pelajaran.xlsx');

      await file.writeAsBytes(bytes);

      await OpenFilex.open(file.path);
    } catch (e) {
      debugPrint('Export excel error: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 768;
    final schedule = widget.schedule ?? [];

    final kelasList = [
      "Semua",
      ...{...schedule.map((s) => s.kelas)},
    ];

    final guruList = [
      "Semua",
      ...{...schedule.map((s) => s.guru)},
    ];

    final hariList = ["Semua", ...widget.school.hariAktif];

    final filtered = schedule.where((s) {
      return (filterKelas == "Semua" || s.kelas == filterKelas) &&
          (filterGuru == "Semua" || s.guru == filterGuru) &&
          (filterHari == "Semua" || s.hari == filterHari);
    }).toList();

    final byDay = <String, List<Gene>>{};

    for (var h in widget.school.hariAktif) {
      byDay[h] = [];
    }

    for (var s in filtered) {
      byDay[s.hari]?.add(s);
    }

    final subjectColorMap = <String, Map<String, Color>>{};
    final allSubjects = {...schedule.map((s) => s.mapelNama)};

    final themeColors = SubjectColorTheme.of(context).subjectColors;
    final colorKeys = themeColors.keys.toList();

    for (var s in allSubjects) {
      final normalizedName = s.toLowerCase().replaceAll(' ', '_');

      final colorKey = colorKeys.firstWhere(
        (key) => normalizedName.contains(key) || key.contains(normalizedName),
        orElse: () =>
            colorKeys[allSubjects.toList().indexOf(s) % colorKeys.length],
      );

      subjectColorMap[s] = themeColors[colorKey]!;
    }

    final totalKonflik = schedule.fold(0, (acc, gene) {
      var c = 0;

      for (var i = schedule.indexOf(gene) + 1; i < schedule.length; i++) {
        final g2 = schedule[i];

        if (gene.guru == g2.guru &&
            gene.hari == g2.hari &&
            gene.slot == g2.slot) {
          c++;
        }

        if (gene.kelas == g2.kelas &&
            gene.hari == g2.hari &&
            gene.slot == g2.slot) {
          c++;
        }
      }

      return acc + c;
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF060816),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HERO
                      _GlassContainer(
                        radius: 34,
                        padding: const EdgeInsets.all(28),
                        glow: const Color(0xFF6366F1),
                        child: LayoutBuilder(
                          builder: (context, c) {
                            final mobile = c.maxWidth < 760;

                            return Flex(
                              direction: mobile
                                  ? Axis.vertical
                                  : Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                mobile
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: Colors.white.withValues(
                                                alpha: 0.08,
                                              ),
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: 0.08,
                                                ),
                                              ),
                                            ),
                                            child: const Text(
                                              '✨ Jadwal berhasil dibuat',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 18),

                                          const Text(
                                            'Optimasi Jadwal Selesai',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 34,
                                              letterSpacing: -1,
                                              height: 1,
                                            ),
                                          ),

                                          const SizedBox(height: 14),

                                          Text(
                                            'Fitness Score: ${widget.fitnessHistory.isEmpty ? 0 : widget.fitnessHistory.last.fitness} • ${schedule.length} sesi berhasil dijadwalkan',
                                            style: TextStyle(
                                              color: Colors.white.withValues(
                                                alpha: 0.72,
                                              ),
                                              fontSize: 15,
                                              height: 1.5,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.white.withValues(
                                                  alpha: 0.08,
                                                ),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.08),
                                                ),
                                              ),
                                              child: const Text(
                                                '✨ Jadwal berhasil dibuat',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),

                                            const SizedBox(height: 18),

                                            const Text(
                                              'Optimasi Jadwal Selesai',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 34,
                                                letterSpacing: -1,
                                                height: 1,
                                              ),
                                            ),

                                            const SizedBox(height: 14),

                                            Text(
                                              'Fitness Score: ${widget.fitnessHistory.isEmpty ? 0 : widget.fitnessHistory.last.fitness} • ${schedule.length} sesi berhasil dijadwalkan',
                                              style: TextStyle(
                                                color: Colors.white.withValues(
                                                  alpha: 0.72,
                                                ),
                                                fontSize: 15,
                                                height: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                SizedBox(
                                  width: mobile ? 0 : 28,
                                  height: mobile ? 28 : 0,
                                ),

                                Wrap(
                                  spacing: 14,
                                  runSpacing: 14,
                                  children: [
                                    _heroStat(
                                      '📋',
                                      schedule.length.toString(),
                                      'Total Sesi',
                                    ),

                                    _heroStat(
                                      '⚠️',
                                      totalKonflik.toString(),
                                      'Konflik',
                                    ),

                                    _heroStat(
                                      '🏫',
                                      '${{...schedule.map((e) => e.kelas)}.length}',
                                      'Kelas',
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// CHART
                      _glassCard(
                        icon: '📊',
                        title: 'Visualisasi Evolusi',
                        subtitle: 'Progress fitness tiap generasi',
                        child: FitnessChart(history: widget.fitnessHistory),
                      ),

                      const SizedBox(height: 24),

                      /// SCHEDULE
                      _glassCard(
                        icon: '📅',
                        title: 'Hasil Jadwal Pelajaran',
                        subtitle: 'Filter dan eksplor jadwal',
                        child: ScheduleTable(
                          schedule: filtered,
                          school: widget.school,
                          byDay: byDay,
                          subjectColorMap: subjectColorMap,
                          totalKonflik: totalKonflik,
                          kelasList: kelasList,
                          guruList: guruList,
                          hariList: hariList,
                          filterKelas: filterKelas,
                          filterGuru: filterGuru,
                          filterHari: filterHari,
                          onFilterKelas: (v) {
                            setState(() => filterKelas = v);
                          },
                          onFilterGuru: (v) {
                            setState(() => filterGuru = v);
                          },
                          onFilterHari: (v) {
                            setState(() => filterHari = v);
                          },
                          onDownload: _onDownload,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

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
                          onTap: widget.onTapBack,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: _buildNavbarBrand(),
                          ),
                        ),

                        GestureDetector(
                          onTap: widget.onEdit,
                          child: Container(
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
                              'Edit Form',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
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

  Widget _glassCard({
    required String icon,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return _GlassContainer(
      radius: 32,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.62),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
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

          child,
        ],
      ),
    );
  }

  Widget _heroStat(String emoji, String value, String label) {
    return _GlassContainer(
      radius: 24,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: SizedBox(
        width: 110,
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 26,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.65),
                fontSize: 12,
              ),
            ),
          ],
        ),
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
              'JadwalPintar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'AI School Scheduler',
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

class _GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final Color? glow;

  const _GlassContainer({
    required this.child,
    this.padding,
    this.radius = 24,
    this.glow,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.10),
                Colors.white.withValues(alpha: 0.03),
              ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            boxShadow: [
              BoxShadow(
                color: (glow ?? Colors.black).withValues(alpha: 0.20),
                blurRadius: 40,
                spreadRadius: -10,
                offset: const Offset(0, 24),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class FitnessChart extends StatelessWidget {
  final List<FitnessHistory> history;

  const FitnessChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        Row(
          children: [
            _legend('Best Fitness', const Color(0xFF818CF8)),

            const SizedBox(width: 16),

            _legend('Avg Fitness', const Color(0xFFA78BFA)),
          ],
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 240,
          child: LineChart(
            LineChartData(
              minY: 0,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) {
                  return FlLine(
                    color: Colors.white.withValues(alpha: 0.05),
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 38,
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final gen = value.toInt();

                      if (gen % 10 == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'G$gen',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.45),
                              fontSize: 10,
                            ),
                          ),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: history
                      .map(
                        (p) => FlSpot(p.gen.toDouble(), p.fitness.toDouble()),
                      )
                      .toList(),
                  isCurved: true,
                  color: const Color(0xFF818CF8),
                  barWidth: 3,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xFF818CF8).withValues(alpha: 0.08),
                  ),
                ),

                LineChartBarData(
                  spots: history
                      .map((p) => FlSpot(p.gen.toDouble(), p.avg))
                      .toList(),
                  isCurved: true,
                  color: const Color(0xFFA78BFA),
                  barWidth: 2,
                  dashArray: [6, 4],
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _legend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100),
          ),
        ),

        const SizedBox(width: 6),

        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.65),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class ScheduleTable extends StatelessWidget {
  final void Function(List<Gene> p0) onDownload;
  final List<Gene> schedule;
  final School school;
  final Map<String, List<Gene>> byDay;
  final Map<String, Map<String, Color>> subjectColorMap;
  final int totalKonflik;

  final List<String> kelasList;
  final List<String> guruList;
  final List<String> hariList;

  final String filterKelas;
  final String filterGuru;
  final String filterHari;

  final Function(String) onFilterKelas;
  final Function(String) onFilterGuru;
  final Function(String) onFilterHari;

  const ScheduleTable({
    super.key,
    required this.schedule,
    required this.school,
    required this.byDay,
    required this.subjectColorMap,
    required this.totalKonflik,
    required this.kelasList,
    required this.guruList,
    required this.hariList,
    required this.filterKelas,
    required this.filterGuru,
    required this.filterHari,
    required this.onFilterKelas,
    required this.onFilterGuru,
    required this.onFilterHari,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// FILTERS
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            _glassDropdown(
              label: 'Kelas',
              value: filterKelas,
              items: kelasList,
              onChanged: onFilterKelas,
            ),

            _glassDropdown(
              label: 'Guru',
              value: filterGuru,
              items: guruList,
              onChanged: onFilterGuru,
            ),

            _glassDropdown(
              label: 'Hari',
              value: filterHari,
              items: hariList,
              onChanged: onFilterHari,
            ),

            _actionButton(
              icon: Icons.download_rounded,
              label: 'Download',
              glow: true,
              onTap: () => onDownload(schedule),
            ),
          ],
        ),

        const SizedBox(height: 28),

        /// DAYS
        ...school.hariAktif
            .where((h) => filterHari == "Semua" || filterHari == h)
            .map((hari) {
              final sessions = byDay[hari] ?? [];

              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _GlassContainer(
                  radius: 28,
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF8B5CF6,
                                  ).withValues(alpha: 0.35),
                                  blurRadius: 20,
                                  spreadRadius: -4,
                                ),
                              ],
                            ),
                            child: Text(
                              hari,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Text(
                            '${sessions.length} sesi',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// EMPTY
                      if (sessions.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white.withValues(alpha: 0.03),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Tidak ada sesi pada hari ini',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.45),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sessions.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    MediaQuery.of(context).size.width < 800
                                    ? 1
                                    : 3,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                childAspectRatio: 1.75,
                              ),
                          itemBuilder: (context, index) {
                            final s = sessions[index];

                            final colors = subjectColorMap[s.mapelNama] ?? {};

                            final bg = colors['bg'] ?? const Color(0xFF1E293B);

                            final border =
                                colors['border'] ?? const Color(0xFF334155);

                            final text = colors['text'] ?? Colors.white;

                            return ClipRRect(
                              borderRadius: BorderRadius.circular(26),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 16,
                                  sigmaY: 16,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        bg.withValues(alpha: 0.42),
                                        bg.withValues(alpha: 0.18),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: border.withValues(alpha: 0.45),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: border.withValues(alpha: 0.25),
                                        blurRadius: 24,
                                        spreadRadius: -8,
                                        offset: const Offset(0, 18),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: Colors.white.withValues(
                                                alpha: 0.10,
                                              ),
                                            ),
                                            child: Text(
                                              s.slot,
                                              style: TextStyle(
                                                color: text,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),

                                          const Spacer(),

                                          Icon(
                                            Icons.auto_awesome_rounded,
                                            color: text.withValues(alpha: 0.85),
                                            size: 18,
                                          ),
                                        ],
                                      ),

                                      const Spacer(),

                                      Text(
                                        s.mapelNama,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: text,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 17,
                                          height: 1.1,
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      _infoRow(Icons.school_rounded, s.kelas),

                                      const SizedBox(height: 7),

                                      _infoRow(Icons.person_rounded, s.guru),

                                      const SizedBox(height: 7),

                                      _infoRow(
                                        Icons.meeting_room_rounded,
                                        'Ruang ${s.ruang}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }

  Widget _glassDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(18),
          iconEnabledColor: Colors.white70,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          items: items.map((e) {
            return DropdownMenuItem<String>(value: e, child: Text(e));
          }).toList(),
          onChanged: (v) {
            if (v != null) {
              onChanged(v);
            }
          },
          selectedItemBuilder: (context) {
            return items.map((e) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$label: ',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 12,
                    ),
                  ),
                  Text(e, style: const TextStyle(color: Colors.white)),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    bool glow = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: glow
              ? const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                )
              : null,
          color: glow ? null : Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          boxShadow: glow
              ? [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                    blurRadius: 24,
                    spreadRadius: -8,
                    offset: const Offset(0, 16),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),

            const SizedBox(width: 8),

            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 15, color: Colors.white.withValues(alpha: 0.70)),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
