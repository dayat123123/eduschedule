import 'dart:ui';
import 'package:flutter/material.dart';

class GeneratingScreen extends StatefulWidget {
  final int progress;
  final int fitness;
  final int total;

  const GeneratingScreen({
    super.key,
    required this.progress,
    required this.fitness,
    required this.total,
  });

  @override
  State<GeneratingScreen> createState() => _GeneratingScreenState();
}

class _GeneratingScreenState extends State<GeneratingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pct = widget.total > 0
        ? ((widget.progress / widget.total) * 100).clamp(0, 100).round()
        : 0;

    final phases = [
      "Inisialisasi populasi...",
      "Evaluasi fitness...",
      "Seleksi elitisme...",
      "Crossover kromosom...",
      "Mutasi gen...",
      "Evolusi generasi baru...",
    ];

    final phase = phases[widget.progress % phases.length];

    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Scaffold(
      backgroundColor: const Color(0xFF060816),
      body: Stack(
        children: [
          // ===== BACKGROUND GLOW =====
          Positioned(
            top: -120,
            left: -80,
            child: _blurOrb(size: 260, color: const Color(0xFF6366F1)),
          ),

          Positioned(
            bottom: -120,
            right: -80,
            child: _blurOrb(size: 300, color: const Color(0xFF8B5CF6)),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xFF0B1020), const Color(0xFF070B17)],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 18 : 28),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 720),
                      padding: EdgeInsets.all(isMobile ? 24 : 34),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(34),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.10),
                            Colors.white.withValues(alpha: 0.04),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.10),
                            blurRadius: 40,
                            spreadRadius: -10,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ===== DNA ICON =====
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (_, _) {
                              return Transform.rotate(
                                angle: _controller.value * 6.28,
                                child: Container(
                                  width: isMobile ? 86 : 104,
                                  height: isMobile ? 86 : 104,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        const Color(
                                          0xFF6366F1,
                                        ).withValues(alpha: 0.95),
                                        const Color(
                                          0xFF8B5CF6,
                                        ).withValues(alpha: 0.95),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.25,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF8B5CF6,
                                        ).withValues(alpha: 0.40),
                                        blurRadius: 30,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '🧬',
                                      style: TextStyle(fontSize: 42),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: isMobile ? 24 : 30),

                          // ===== TITLE =====
                          Text(
                            'Algoritma Genetika Sedang Berjalan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isMobile ? 22 : 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            phase,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isMobile ? 13 : 15,
                              color: Colors.white.withValues(alpha: 0.65),
                              height: 1.5,
                            ),
                          ),

                          SizedBox(height: isMobile ? 28 : 36),

                          // ===== PROGRESS =====
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.08,
                                        ),
                                      ),
                                    ),

                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 450,
                                      ),
                                      curve: Curves.easeOutCubic,
                                      width:
                                          ((pct / 100) *
                                          (isMobile ? 280 : 540)),
                                      height: 14,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF6366F1),
                                            Color(0xFF8B5CF6),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF8B5CF6,
                                            ).withValues(alpha: 0.45),
                                            blurRadius: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Generasi ${widget.progress}',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.75,
                                      ),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '$pct%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: isMobile ? 26 : 34),

                          // ===== STATS =====
                          Wrap(
                            spacing: 14,
                            runSpacing: 14,
                            alignment: WrapAlignment.center,
                            children: [
                              _glassStat(
                                icon: Icons.auto_graph_rounded,
                                label: 'Generasi',
                                value: widget.progress.toString(),
                              ),
                              _glassStat(
                                icon: Icons.bolt_rounded,
                                label: 'Fitness',
                                value: widget.fitness.toString(),
                              ),
                              _glassStat(
                                icon: Icons.timelapse_rounded,
                                label: 'Progress',
                                value: '$pct%',
                              ),
                            ],
                          ),

                          SizedBox(height: isMobile ? 24 : 30),

                          // ===== FOOTER =====
                          Text(
                            'Sistem sedang mencari kombinasi jadwal terbaik...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.5),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
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

  Widget _glassStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white.withValues(alpha: 0.06),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6366F1).withValues(alpha: 0.9),
                      const Color(0xFF8B5CF6).withValues(alpha: 0.9),
                    ],
                  ),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),

              const SizedBox(height: 14),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _blurOrb({required double size, required Color color}) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}
