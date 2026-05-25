// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models.dart';

// class ApiService {
//   static const String baseUrl =
//       'http://localhost:3000/api'; // Change to your server URL

//   // Headers for API requests
//   static const Map<String, String> headers = {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//   };

//   /// Generate schedule via API
//   ///
//   /// Sends all form data to the backend server and receives the generated schedule
//   static Future<Map<String, dynamic>> generateSchedule({
//     required School school,
//     required List<Subject> subjects,
//     required List<Teacher> teachers,
//     required Constraints constraints,
//     required GAConfig gaConfig,
//     required Function(int, int) onProgress, // (generation, fitness)
//   }) async {
//     try {
//       final requestData = {
//         'school': _schoolToJson(school),
//         'subjects': subjects.map(_subjectToJson).toList(),
//         'teachers': teachers.map(_teacherToJson).toList(),
//         'constraints': _constraintsToJson(constraints),
//         'gaConfig': _gaConfigToJson(gaConfig),
//       };

//       final response = await http
//           .post(
//             Uri.parse('$baseUrl/schedule/generate'),
//             headers: headers,
//             body: jsonEncode(requestData),
//           )
//           .timeout(
//             const Duration(minutes: 5),
//             onTimeout: () =>
//                 throw Exception('Request timeout - generation took too long'),
//           );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return {
//           'schedule': _parseSchedule(data['schedule'] ?? []),
//           'fitnessHistory': _parseFitnessHistory(data['fitnessHistory'] ?? []),
//           'finalFitness': data['finalFitness'] ?? 0,
//           'success': true,
//         };
//       } else if (response.statusCode == 400) {
//         final error = jsonDecode(response.body);
//         throw Exception(error['message'] ?? 'Invalid request data');
//       } else if (response.statusCode == 500) {
//         throw Exception('Server error - please try again later');
//       } else {
//         throw Exception('Unknown error (${response.statusCode})');
//       }
//     } on http.ClientException catch (e) {
//       throw Exception('Network error: ${e.message}');
//     } catch (e) {
//       throw Exception('Error generating schedule: $e');
//     }
//   }

//   /// Validate schedule via API
//   static Future<Map<String, dynamic>> validateSchedule({
//     required School school,
//     required List<Subject> subjects,
//     required List<Teacher> teachers,
//   }) async {
//     try {
//       final requestData = {
//         'school': _schoolToJson(school),
//         'subjects': subjects.map(_subjectToJson).toList(),
//         'teachers': teachers.map(_teacherToJson).toList(),
//       };

//       final response = await http.post(
//         Uri.parse('$baseUrl/schedule/validate'),
//         headers: headers,
//         body: jsonEncode(requestData),
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception('Validation failed');
//       }
//     } catch (e) {
//       throw Exception('Validation error: $e');
//     }
//   }

//   // ============= Helper Methods =============

//   static Map<String, dynamic> _schoolToJson(School school) {
//     return {
//       'nama': school.nama,
//       'jumlahHari': school.jumlahHari,
//       'hariAktif': school.hariAktif,
//       'jamMulai': school.jamMulai,
//       'jamSelesai': school.jamSelesai,
//       'durasiSesi': school.durasiSesi,
//       'jumlahRuang': school.jumlahRuang,
//     };
//   }

//   static Map<String, dynamic> _subjectToJson(Subject subject) {
//     return {
//       'id': subject.id,
//       'nama': subject.nama,
//       'kelas': subject.kelas,
//       'jamPerMinggu': subject.jamPerMinggu,
//       'guru': subject.guru,
//     };
//   }

//   static Map<String, dynamic> _teacherToJson(Teacher teacher) {
//     return {
//       'id': teacher.id,
//       'nama': teacher.nama,
//       'mapel': teacher.mapel,
//       'maxJamPerHari': teacher.maxJamPerHari,
//       'preferensiHari': teacher.preferensiHari,
//       'hariTidakBisa': teacher.hariTidakBisa,
//     };
//   }

//   static Map<String, dynamic> _constraintsToJson(Constraints constraints) {
//     return {
//       'guruTidakBentrok': constraints.guruTidakBentrok,
//       'kelasTidakBentrok': constraints.kelasTidakBentrok,
//       'ruangTidakBentrok': constraints.ruangTidakBentrok,
//       'hindariJamKosong': constraints.hindariJamKosong,
//       'prioritasPreferensiGuru': constraints.prioritasPreferensiGuru,
//       'maxBeratPerHari': constraints.maxBeratPerHari,
//       'maxBerturutan': constraints.maxBerturutan,
//     };
//   }

//   static Map<String, dynamic> _gaConfigToJson(GAConfig config) {
//     return {
//       'populationSize': config.populationSize,
//       'mutationRate': config.mutationRate,
//       'crossoverRate': config.crossoverRate,
//       'maxGeneration': config.maxGeneration,
//       'eliteSize': config.eliteSize,
//     };
//   }

//   static List<Gene> _parseSchedule(List<dynamic> scheduleData) {
//     return scheduleData.map((item) {
//       return Gene(
//         mapelId: item['mapelId'] ?? 0,
//         mapelNama: item['mapelNama'] ?? '',
//         kelas: item['kelas'] ?? '',
//         guru: item['guru'] ?? '',
//         hari: item['hari'] ?? '',
//         slot: item['slot'] ?? '',
//         ruang: item['ruang'] ?? 0,
//       );
//     }).toList();
//   }

//   static List<FitnessHistory> _parseFitnessHistory(List<dynamic> historyData) {
//     return historyData.map((item) {
//       return FitnessHistory(
//         generation: item['generation'] ?? 0,
//         bestFitness: item['bestFitness'] ?? 0,
//         avgFitness: item['avgFitness'] ?? 0,
//       );
//     }).toList();
//   }
// }
