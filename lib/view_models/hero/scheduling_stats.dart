class SchedulingStats {
  final double optimizationPercentage; // Contoh: 98.5 untuk 98.5%
  final int totalConflicts; // Jumlah bentrok, misal: 0
  final double calculationTimeSeconds; // Waktu proses algoritma, misal: 12.4
  final int
  totalScenariosGenerated; // Jumlah alternatif kombinasi yang dievaluasi
  final int
  totalSchedulesProcessed; // JUMLAH TOTAL JADWAL YANG SUDAH DIPROSES/SELESAI
  final DateTime lastUpdated; // Waktu pembaruan data terakhir

  const SchedulingStats({
    required this.optimizationPercentage,
    required this.totalConflicts,
    required this.calculationTimeSeconds,
    required this.totalScenariosGenerated,
    required this.totalSchedulesProcessed,
    required this.lastUpdated,
  });

  // Getter pembantu untuk memformat tampilan string di UI secara rapi
  String get formattedOptimization =>
      '${optimizationPercentage.toStringAsFixed(0)}%';
  String get formattedConflicts =>
      totalConflicts == 0 ? '0 Konflik' : '$totalConflicts Bentrok';
  String get formattedTime => '< ${calculationTimeSeconds.ceil()}s';
  String get formattedScenarios => totalScenariosGenerated >= 1000
      ? '${(totalScenariosGenerated / 1000).toStringAsFixed(1)}rb Skenario'
      : '$totalScenariosGenerated Skenario';
  String get formattedTotalProcessed => totalSchedulesProcessed >= 1000
      ? '${(totalSchedulesProcessed / 1000).toStringAsFixed(1)}k+ Sukses'
      : '$totalSchedulesProcessed Jadwal';

  // Factory untuk memetakan data dari JSON / API jika nanti terhubung ke Backend
  factory SchedulingStats.fromJson(Map<String, dynamic> json) {
    return SchedulingStats(
      optimizationPercentage:
          (json['optimization_percentage'] as num?)?.toDouble() ?? 0.0,
      totalConflicts: json['total_conflicts'] as int? ?? 0,
      calculationTimeSeconds:
          (json['calculation_time_seconds'] as num?)?.toDouble() ?? 0.0,
      totalScenariosGenerated: json['total_scenarios_generated'] as int? ?? 0,
      totalSchedulesProcessed: json['total_schedules_processed'] as int? ?? 0,
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'])
          : DateTime.now(),
    );
  }

  // Objek tiruan (Mock Data) untuk keperluan testing atau default state di UI
  factory SchedulingStats.mock() {
    return SchedulingStats(
      optimizationPercentage: 98.0,
      totalConflicts: 0,
      calculationTimeSeconds: 28.5,
      totalScenariosGenerated: 154000,
      totalSchedulesProcessed:
          1250, // Menunjukkan sudah ada 1,250 jadwal sekolah sukses dibuat
      lastUpdated: DateTime.now(),
    );
  }
}
