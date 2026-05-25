import 'dart:async'; // WAJIB DIIMPORT untuk menggunakan Timer
import 'package:eduschedule/view_models/hero/scheduling_stats.dart';
import 'package:flutter/material.dart';

enum HeroState { initial, loading, loaded, error }

class HeroViewModel extends ChangeNotifier {
  HeroState _state = HeroState.initial;
  SchedulingStats? _stats;
  String _errorMessage = '';

  // Timer instance untuk mengelola polling background
  Timer? _pollingTimer;

  HeroState get state => _state;
  SchedulingStats? get stats => _stats;
  String get errorMessage => _errorMessage;

  bool get isLoading => _state == HeroState.loading;
  bool get hasError => _state == HeroState.error;
  bool get isLoaded => _state == HeroState.loaded;

  /// 1. Fungsi Utama untuk mengaktifkan Fetch Berkala
  void startStatsPolling({int intervalSeconds = 10}) {
    // Cegah duplikasi timer jika fungsi ini tidak sengaja dipanggil dua kali
    stopStatsPolling();

    // Jalankan fetch pertama kali secara langsung
    fetchSchedulingStats(isInitialLoad: _stats == null);

    // Set interval berkala untuk background refresh
    _pollingTimer = Timer.periodic(Duration(seconds: intervalSeconds), (timer) {
      // isInitialLoad diberi nilai false agar UI tidak memunculkan animasi loading di tengah-tengah
      fetchSchedulingStats(isInitialLoad: false);
    });
  }

  /// 2. Fungsi Utama Fetch Data (Asynchronous)
  Future<void> fetchSchedulingStats({bool isInitialLoad = true}) async {
    // Hanya tampilkan full-screen loading jika memang request pertama kali atau data kosong
    if (isInitialLoad) {
      _state = HeroState.loading;
      notifyListeners();
    }

    try {
      // TODO: Hubungkan ke API Service atau Repository asli Anda disini
      // Contoh: final response = await _apiService.getDashboardStats();
      // _stats = SchedulingStats.fromJson(response.data);

      // Simulasi latency jaringan selama 1 detik
      await Future.delayed(const Duration(seconds: 1));

      // Simulasi update data agar terlihat perubahannya saat berkala (opsional untuk testing)
      _stats = SchedulingStats.mock();

      _state = HeroState.loaded;
    } catch (e) {
      // Jika background refresh gagal tapi data lama sudah ada, pertahankan data lama
      // Hanya set state error jika data sama sekali belum pernah berhasil di-load
      if (_stats == null) {
        _errorMessage = 'Gagal memuat statistik sistem: ${e.toString()}';
        _state = HeroState.error;
      }
    } finally {
      notifyListeners(); // Render ulang widget statistik dengan data terbaru
    }
  }

  /// 3. Fungsi Pembersihan (Sangat penting untuk performa aplikasi)
  void stopStatsPolling() {
    if (_pollingTimer != null && _pollingTimer!.isActive) {
      _pollingTimer!.cancel();
    }
  }

  @override
  void dispose() {
    stopStatsPolling(); // Pastikan timer mati total saat ViewModel dihancurkan/screen ditutup
    super.dispose();
  }
}
