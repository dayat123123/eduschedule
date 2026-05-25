import 'dart:ui';
import 'package:flutter/material.dart';

import '../theme.dart';

class HeroScreen extends StatefulWidget {
  final VoidCallback onStart;

  const HeroScreen({super.key, required this.onStart});

  @override
  State<HeroScreen> createState() => _HeroScreenState();
}

class _HeroScreenState extends State<HeroScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Definisi Key untuk Auto-Scroll
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
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

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.heroBackground,
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // 1. Background Gradient Tetap di Lapisan Paling Bawah
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.heroBackground,
                    AppColors.heroGradientStart,
                    AppColors.heroGradientMiddle,
                    AppColors.heroGradientEnd,
                  ],
                ),
              ),
            ),
          ),

          // Ambient Glow Decor
          Positioned(
            top: screenSize.height * 0.15,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
          ),

          // 2. Main Scrollable Content
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 85),

                  _buildHeroSection(context, isMobile),
                  _buildFeaturesSection(isMobile),
                  _buildWorkflowSection(isMobile),
                  _buildAboutSection(isMobile),
                  _buildEducationQuoteSection(isMobile),
                  _buildFooter(),
                ],
              ),
            ),
          ),

          // 3. Floating Navbar dengan Efek Glassmorphism (Tetap Pinned di Atas)
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
                    color: AppColors.heroBackground.withValues(alpha: 0.35),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withValues(alpha: 0.06),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNavbarBrand(),
                      if (isMobile)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () =>
                                _scaffoldKey.currentState?.openDrawer(),
                            icon: const Icon(
                              Icons.menu_rounded,
                              color: Colors.white,
                            ),
                          ),
                        )
                      else
                        Row(
                          children: [
                            _navButton(
                              'Beranda',
                              () => _scrollToSection(_heroKey),
                            ),
                            _navButton(
                              'Fitur',
                              () => _scrollToSection(_featuresKey),
                            ),
                            _navButton(
                              'Tentang',
                              () => _scrollToSection(_aboutKey),
                            ),
                            const SizedBox(width: 24),
                            _buildCtaButtonSmall(),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- COMPONENT WIDGETS ---

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

  Widget _buildCtaButtonSmall() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accentPurple],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: widget.onStart,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Mulai Sekarang',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isMobile) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      key: _heroKey,
      constraints: BoxConstraints(minHeight: screenHeight - 85),
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isMobile ? 40 : 80,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.accentPurpleUltraLight.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppColors.accentPurpleLight.withValues(alpha: 0.3),
                ),
              ),
              child: const Text(
                '⏰ Optimalkan Jam Mengajar Guru • Tingkatkan Efisiensi Sekolah',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.accentPurpleVeryLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 36),
            Text(
              'Jam Terbaik Guru,\nJadwal Sempurna',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 42 : 72,
                fontWeight: FontWeight.w900,
                letterSpacing: -2.0,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: isMobile ? double.infinity : 700,
              child: const Text(
                'Ciptakan jadwal sekolah yang memaksimalkan jam mengajar guru dan meminimalkan jam kosong. Sistem AI kami menganalisis preferensi guru, beban kerja optimal, dan aturan sekolah untuk menghasilkan jadwal sempurna dalam hitungan detik.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.accentPurpleVeryLight,
                  fontSize: 18,
                  height: 1.7,
                ),
              ),
            ),
            const SizedBox(height: 48),
            Wrap(
              spacing: 20,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.accentPurple],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: widget.onStart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 22,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      '⚡ Mulai Optimalkan Jadwal',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () => _scrollToSection(_featuresKey),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    backgroundColor: Colors.white.withValues(alpha: 0.04),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 22,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Pelajari Lebih Lanjut',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),
            Container(
              constraints: const BoxConstraints(maxWidth: 900),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: const Wrap(
                spacing: 50,
                runSpacing: 28,
                alignment: WrapAlignment.center,
                children: [
                  _StatWidget(number: '98%', label: 'Jam Guru Teroptimasi'),
                  _StatWidget(number: '0 Konflik', label: 'Bentrok Jadwal'),
                  _StatWidget(number: '< 30s', label: 'Kalkulasi Algoritma'),
                  _StatWidget(number: '∞ Skenario', label: 'Alternatif Jadwal'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(bool isMobile) {
    return Container(
      key: _featuresKey,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: 100,
      ),
      color: AppColors.heroBackgroundSecondary,
      child: Column(
        children: [
          const Text(
            'Optimalkan Jam & Efisiensi Guru',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 18),
          const SizedBox(
            width: 700,
            child: Text(
              'Sistem AI dirancang khusus untuk memaksimalkan jam mengajar guru, menghilangkan jam kosong, dan menjaga keseimbangan beban kerja di setiap kelas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.accentPurpleVeryLight,
                fontSize: 17,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 70),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _featureCard(
                isMobile,
                '🎯',
                'Jam Mengajar Teroptimasi',
                'Maksimalkan efisiensi jam guru dengan algoritma cerdas yang meminimalkan jam kosong dan menaikkan pemanfaatan kelas.',
              ),
              _featureCard(
                isMobile,
                '⚖️',
                'Keseimbangan Beban Kerja',
                'Distribusi beban mengajar merata antar guru sesuai dengan kapabilitas dan preferensi mereka.',
              ),
              _featureCard(
                isMobile,
                '🚫',
                'Zero Conflict Guard',
                'Secara ketat mengunci potensi bentrok ruang lab, guru, atau rombongan belajar secara real-time dan akurat.',
              ),
              _featureCard(
                isMobile,
                '🔍',
                'Analitik Beban Kerja Guru',
                'Visualisasi komprehensif menunjukkan efisiensi penggunaan jam dan kapasitas setiap guru per hari.',
              ),
              _featureCard(
                isMobile,
                '📱',
                'Akses Multi-Device',
                'Kelola dan lihat jadwal kapan saja dari laptop, tablet, atau smartphone dengan desain responsif optimal.',
              ),
              _featureCard(
                isMobile,
                '📥',
                'Cetak & Unduh Instan',
                'Ekspor jadwal langsung ke format PDF dan Excel untuk dibagikan ke seluruh civitas akademika sekolah.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowSection(bool isMobile) {
    // Fix overflow: gunakan Wrap horizontal dengan padding & scroll.
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: 100,
      ),
      color: AppColors.heroBackground.withValues(alpha: 0.5),
      child: Column(
        children: [
          const Text(
            'Tiga Langkah Mudah Menuju Jadwal Optimal',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 60),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _workflowStep(
                  '1',
                  'Input Data Guru & Preferensi',
                  'Masukkan data guru, jam mengajar, preferensi hari, dan aturan khusus sekolah Anda.',
                ),
                if (!isMobile)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.primaryLight,
                      size: 32,
                    ),
                  ),
                _workflowStep(
                  '2',
                  'AI Optimalkan Jadwal',
                  'Klik generate, AI menganalisis ribuan kombinasi untuk hasil jadwal terbaik.',
                ),
                if (!isMobile)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.primaryLight,
                      size: 32,
                    ),
                  ),
                _workflowStep(
                  '3',
                  'Publikasi ke Semua',
                  'Jadwal siap dibagikan ke guru, murid, dan orang tua dengan sekali klik.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(bool isMobile) {
    return Container(
      key: _aboutKey,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 60,
        vertical: 100,
      ),
      color: AppColors.heroBackground,
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 950),
            padding: EdgeInsets.all(isMobile ? 24 : 40),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              children: [
                Expanded(
                  flex: isMobile ? 0 : 6,
                  child: Column(
                    crossAxisAlignment: isMobile
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kenapa JadwalPintar Dibutuhkan?',
                        style: TextStyle(
                          color: AppColors.primaryLight,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Menyusun jadwal pelajaran secara manual seringkali menjadi tantangan serius bagi tim kurikulum. Ribuan variabel pembatas, preferensi guru, dan aturan sekolah menciptakan kompleksitas yang sulit dikelola.\n\nJadwalPintar hadir sebagai solusi modern. Kami menggunakan Algoritma Genetika canggih untuk mengoptimalkan setiap jam mengajar guru, meminimalkan jam kosong, dan menghilangkan bentrok. Hasilnya: jadwal sempurna yang membuat guru fokus mengajar, bukan repot mengatur jam.',
                        textAlign: isMobile
                            ? TextAlign.center
                            : TextAlign.start,
                        style: TextStyle(
                          color: AppColors.accentPurpleVeryLight.withValues(
                            alpha: 0.85,
                          ),
                          fontSize: 16,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isMobile) const Spacer(flex: 1),
                if (isMobile) const SizedBox(height: 40),
                Expanded(
                  flex: isMobile ? 0 : 4,
                  child: Container(
                    height: 240,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accentPurple],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.schedule_rounded,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationQuoteSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 60,
        vertical: 100,
      ),
      color: AppColors.heroBackgroundSecondary.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              const Icon(
                Icons.format_quote_rounded,
                color: AppColors.primaryLight,
                size: 60,
              ),
              const SizedBox(height: 24),
              const Text(
                '"Teknologi tidak akan pernah menggantikan guru yang hebat, tetapi teknologi di tangan guru yang hebat akan transformatif."',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'George Couros',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Inovator & Penulis Bidang Pendidikan',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      color: AppColors.heroBackgroundDark,
      child: Column(
        children: [
          const Text(
            'JadwalPintar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: 500,
            child: Text(
              'Mendukung efisiensi administrasi sekolah demi masa depan pendidikan Indonesia yang lebih cerdas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textMuted.withValues(alpha: 0.7),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Divider(color: Colors.white.withValues(alpha: 0.05)),
          const SizedBox(height: 24),
          Text(
            '© ${DateTime.now().year} JadwalPintar Inc. All rights reserved.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Drawer(
          backgroundColor: Colors.transparent,
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.primary,
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'JadwalPintar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'AI School Scheduler',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _drawerItem(
                  icon: Icons.home_rounded,
                  title: 'Beranda',
                  onTap: () {
                    Navigator.pop(context);
                    _scrollToSection(_heroKey);
                  },
                ),
                _drawerItem(
                  icon: Icons.auto_awesome_rounded,
                  title: 'Fitur',
                  onTap: () {
                    Navigator.pop(context);
                    _scrollToSection(_featuresKey);
                  },
                ),
                _drawerItem(
                  icon: Icons.info_outline_rounded,
                  title: 'Tentang',
                  onTap: () {
                    Navigator.pop(context);
                    _scrollToSection(_aboutKey);
                  },
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onStart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Mulai Sekarang',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onTap: onTap,
      ),
    );
  }

  Widget _navButton(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _featureCard(
    bool isMobile,
    String emoji,
    String title,
    String description,
  ) {
    return Container(
      width: isMobile ? double.infinity : 340,
      constraints: BoxConstraints(minHeight: isMobile ? 0 : 260),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.accentPurpleVeryLight,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _workflowStep(String stepNumber, String title, String desc) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: Text(
              stepNumber,
              style: const TextStyle(
                color: AppColors.primaryLight,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.accentPurpleVeryLight.withValues(alpha: 0.7),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatWidget extends StatelessWidget {
  final String number;
  final String label;

  const _StatWidget({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.accentPurpleLight,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
