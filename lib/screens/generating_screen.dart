import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class GeneratingScreen extends StatefulWidget {
  const GeneratingScreen({super.key});

  @override
  State<GeneratingScreen> createState() => _GeneratingScreenState();
}

class _GeneratingScreenState extends State<GeneratingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Timer _phaseTimer;
  int _currentPhaseIndex = 0;

  final List<String> _phases = [
    "Inisialisasi populasi...",
    "Evaluasi fitness...",
    "Seleksi elitisme...",
    "Crossover kromosom...",
    "Mutasi gen...",
    "Evolusi generasi baru...",
  ];

  @override
  void initState() {
    super.initState();

    // Animasi putaran ikon DNA
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // Timer otomatis untuk mengubah teks phase karena parameter sudah dihapus
    _phaseTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _currentPhaseIndex = (_currentPhaseIndex + 1) % _phases.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _phaseTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0B1020), Color(0xFF070B17)],
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
                      constraints: const BoxConstraints(maxWidth: 480),
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
                          // ===== ANIMATED LOADING & DNA ICON =====
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Efek loading melingkar (Circular Glow)
                              SizedBox(
                                width: isMobile ? 114 : 134,
                                height: isMobile ? 114 : 134,
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Color(0xFF8B5CF6),
                                      ),
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.05,
                                  ),
                                ),
                              ),
                              // Ikon DNA berputar di dalam lingkaran loading
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
                            ],
                          ),

                          SizedBox(height: isMobile ? 32 : 38),

                          // ===== TITLE =====
                          Text(
                            'Algoritma Genetika Sedang Berjalan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isMobile ? 22 : 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ===== STATUS TEXT PERUBAHAN FASE =====
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _phases[_currentPhaseIndex],
                              key: ValueKey<int>(_currentPhaseIndex),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF6366F1),
                                height: 1.5,
                              ),
                            ),
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
