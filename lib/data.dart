import 'models.dart';

final dummySchool = School(
  nama: "SMA Negeri 1 Nusantara",
  level: SchoolLevel.sma,
  kelas: "10-A",
  kelasList: SchoolLevel.sma.defaultClasses(count: 3),
  jumlahHari: 5,
  hariAktif: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],
  jamMulai: "07:00",
  jamSelesai: "14:30", // ⬅️ diperpanjang biar aman sesi 7x45
  jamMulaiPerHari: {},
  jamSelesaiPerHari: {},
  durasiSesi: 45,
  jumlahSesi: 7,

  istirahatPerHari: {
    "Senin": [
      SchoolBreak(dari: "09:30", sampai: "09:45"),
      SchoolBreak(dari: "12:00", sampai: "12:30"),
    ],
    "Selasa": [
      SchoolBreak(dari: "09:30", sampai: "09:45"),
      SchoolBreak(dari: "12:00", sampai: "12:30"),
    ],
    "Rabu": [
      SchoolBreak(dari: "09:30", sampai: "09:45"),
      SchoolBreak(dari: "12:00", sampai: "12:30"),
    ],
    "Kamis": [
      SchoolBreak(dari: "09:30", sampai: "09:45"),
      SchoolBreak(dari: "12:00", sampai: "12:30"),
    ],
    "Jumat": [
      SchoolBreak(dari: "09:00", sampai: "09:15"),
      SchoolBreak(dari: "11:45", sampai: "12:15"),
    ],
  },

  durasiSesiList: [],
  samaDurasiSesi: true,
  jumlahRuang: 12,
);

final dummySchoolSD = School(
  nama: "SD Negeri 1 Jakarta",
  level: SchoolLevel.sd,
  kelas: "1-A",
  kelasList: SchoolLevel.sd.defaultClasses(count: 3),
  jumlahHari: 5,
  hariAktif: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],
  jamMulai: "07:00",
  jamSelesai: "11:45",

  jamMulaiPerHari: {},
  jamSelesaiPerHari: {},

  durasiSesi: 35,
  jumlahSesi: 5,

  istirahatPerHari: {
    "Senin": [SchoolBreak(dari: "09:00", sampai: "09:20")],
    "Selasa": [SchoolBreak(dari: "09:00", sampai: "09:20")],
    "Rabu": [SchoolBreak(dari: "09:00", sampai: "09:20")],
    "Kamis": [SchoolBreak(dari: "09:00", sampai: "09:20")],
    "Jumat": [SchoolBreak(dari: "09:00", sampai: "09:30")],
  },

  durasiSesiList: [],
  samaDurasiSesi: true,
  jumlahRuang: 6,
);

final dummySchoolSMP = School(
  nama: "SMP Negeri 2 Bandung",
  level: SchoolLevel.smp,
  kelas: "7-A",
  kelasList: SchoolLevel.smp.defaultClasses(count: 3),
  jumlahHari: 5,
  hariAktif: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],

  jamMulai: "07:00",
  jamSelesai: "14:00",

  jamMulaiPerHari: {},
  jamSelesaiPerHari: {},

  durasiSesi: 40,
  jumlahSesi: 6,

  istirahatPerHari: {
    "Senin": [
      SchoolBreak(dari: "09:15", sampai: "09:30"),
      SchoolBreak(dari: "11:30", sampai: "12:00"),
    ],
    "Selasa": [
      SchoolBreak(dari: "09:15", sampai: "09:30"),
      SchoolBreak(dari: "11:30", sampai: "12:00"),
    ],
    "Rabu": [
      SchoolBreak(dari: "09:15", sampai: "09:30"),
      SchoolBreak(dari: "11:30", sampai: "12:00"),
    ],
    "Kamis": [
      SchoolBreak(dari: "09:15", sampai: "09:30"),
      SchoolBreak(dari: "11:30", sampai: "12:00"),
    ],
    "Jumat": [
      SchoolBreak(dari: "09:00", sampai: "09:15"),
      SchoolBreak(dari: "11:30", sampai: "12:15"),
    ],
  },

  durasiSesiList: [],
  samaDurasiSesi: true,
  jumlahRuang: 8,
);

final List<Subject> dummyMapel = [
  Subject(
    id: 1,
    nama: "Matematika",
    kelas: "10-A",
    jamPerMinggu: 4,
    guru: "Budi Santoso",
    durasiPerSesi: 45,
  ),
  Subject(
    id: 2,
    nama: "Fisika",
    kelas: "10-A",
    jamPerMinggu: 3,
    guru: "Siti Rahayu",
    durasiPerSesi: 45,
  ),
  Subject(
    id: 3,
    nama: "Kimia",
    kelas: "10-A",
    jamPerMinggu: 3,
    guru: "Ahmad Fauzi",
    durasiPerSesi: 45,
  ),
  Subject(
    id: 4,
    nama: "Bahasa Indonesia",
    kelas: "10-A",
    jamPerMinggu: 4,
    guru: "Dewi Lestari",
    durasiPerSesi: 45,
  ),
  Subject(
    id: 5,
    nama: "Bahasa Inggris",
    kelas: "10-A",
    jamPerMinggu: 4,
    guru: "Rini Wulandari",
    durasiPerSesi: 45,
  ),
  Subject(
    id: 6,
    nama: "Biologi",
    kelas: "10-B",
    jamPerMinggu: 3,
    guru: "Hendra Kurniawan",
    durasiPerSesi: 45,
  ),
  Subject(
    id: 7,
    nama: "Sejarah",
    kelas: "10-B",
    jamPerMinggu: 2,
    guru: "Agus Priyanto",
    durasiPerSesi: 45,
  ),
];

// Sample subjects for different school levels
List<Subject> getDummySubjectsForLevel(SchoolLevel level) {
  switch (level) {
    case SchoolLevel.sd:
      return [
        Subject(
          id: 1,
          nama: "Bahasa Indonesia",
          kelas: "1-A",
          jamPerMinggu: 6,
          guru: "Ibu Siti",
          durasiPerSesi: 35,
        ),
        Subject(
          id: 2,
          nama: "Matematika",
          kelas: "1-A",
          jamPerMinggu: 5,
          guru: "Pak Budi",
          durasiPerSesi: 35,
        ),
        Subject(
          id: 3,
          nama: "IPA",
          kelas: "1-A",
          jamPerMinggu: 4,
          guru: "Bu Rina",
          durasiPerSesi: 35,
        ),
        Subject(
          id: 4,
          nama: "IPS",
          kelas: "1-A",
          jamPerMinggu: 3,
          guru: "Pak Ahmad",
          durasiPerSesi: 35,
        ),
        Subject(
          id: 5,
          nama: "Bahasa Inggris",
          kelas: "1-A",
          jamPerMinggu: 3,
          guru: "Bu Lisa",
          durasiPerSesi: 35,
        ),
        Subject(
          id: 6,
          nama: "PKN",
          kelas: "1-A",
          jamPerMinggu: 2,
          guru: "Pak Joko",
          durasiPerSesi: 35,
        ),
        Subject(
          id: 7,
          nama: "Agama",
          kelas: "1-A",
          jamPerMinggu: 3,
          guru: "Ust. Hasan",
          durasiPerSesi: 35,
        ),
        Subject(
          id: 8,
          nama: "Seni Budaya",
          kelas: "1-A",
          jamPerMinggu: 2,
          guru: "Bu Maya",
          durasiPerSesi: 35,
        ),
        Subject(
          id: 9,
          nama: "Penjasorkes",
          kelas: "1-A",
          jamPerMinggu: 3,
          guru: "Pak Dedi",
          durasiPerSesi: 35,
        ),
      ];
    case SchoolLevel.smp:
      return [
        Subject(
          id: 1,
          nama: "Bahasa Indonesia",
          kelas: "7-A",
          jamPerMinggu: 4,
          guru: "Ibu Siti",
          durasiPerSesi: 40,
        ),
        Subject(
          id: 2,
          nama: "Matematika",
          kelas: "7-A",
          jamPerMinggu: 4,
          guru: "Pak Budi",
          durasiPerSesi: 40,
        ),
        Subject(
          id: 3,
          nama: "IPA",
          kelas: "7-A",
          jamPerMinggu: 4,
          guru: "Bu Rina",
          durasiPerSesi: 40,
        ),
        Subject(
          id: 4,
          nama: "IPS",
          kelas: "7-A",
          jamPerMinggu: 4,
          guru: "Pak Ahmad",
          durasiPerSesi: 40,
        ),
        Subject(
          id: 5,
          nama: "Bahasa Inggris",
          kelas: "7-A",
          jamPerMinggu: 3,
          guru: "Bu Lisa",
          durasiPerSesi: 40,
        ),
        Subject(
          id: 6,
          nama: "PKN",
          kelas: "7-A",
          jamPerMinggu: 2,
          guru: "Pak Joko",
          durasiPerSesi: 40,
        ),
        Subject(
          id: 7,
          nama: "Agama",
          kelas: "7-A",
          jamPerMinggu: 3,
          guru: "Ust. Hasan",
          durasiPerSesi: 40,
        ),
        Subject(
          id: 8,
          nama: "Seni Budaya",
          kelas: "7-A",
          jamPerMinggu: 2,
          guru: "Bu Maya",
          durasiPerSesi: 40,
        ),
        Subject(
          id: 9,
          nama: "Penjasorkes",
          kelas: "7-A",
          jamPerMinggu: 3,
          guru: "Pak Dedi",
          durasiPerSesi: 40,
        ),
        Subject(
          id: 10,
          nama: "Prakarya",
          kelas: "7-A",
          jamPerMinggu: 2,
          guru: "Bu Sari",
          durasiPerSesi: 40,
        ),
      ];
    case SchoolLevel.sma:
      return dummyMapel; // Use existing SMA subjects
  }
}

final List<Teacher> dummyGuru = [
  Teacher(
    id: 1,
    nama: "Budi Santoso",
    mapel: ["Matematika"],
    maxJamPerHari: 4,
    preferensiHari: ["Senin", "Rabu", "Jumat"],
    hariTidakBisa: [],
  ),
  Teacher(
    id: 2,
    nama: "Siti Rahayu",
    mapel: ["Fisika"],
    maxJamPerHari: 3,
    preferensiHari: ["Selasa", "Kamis"],
    hariTidakBisa: [],
  ),
  Teacher(
    id: 3,
    nama: "Ahmad Fauzi",
    mapel: ["Kimia"],
    maxJamPerHari: 3,
    preferensiHari: ["Senin", "Rabu"],
    hariTidakBisa: ["Jumat"],
  ),
  Teacher(
    id: 4,
    nama: "Dewi Lestari",
    mapel: ["Bahasa Indonesia"],
    maxJamPerHari: 4,
    preferensiHari: ["Selasa", "Kamis", "Jumat"],
    hariTidakBisa: [],
  ),
  Teacher(
    id: 5,
    nama: "Rini Wulandari",
    mapel: ["Bahasa Inggris"],
    maxJamPerHari: 4,
    preferensiHari: ["Senin", "Selasa", "Kamis"],
    hariTidakBisa: [],
  ),
  Teacher(
    id: 6,
    nama: "Hendra Kurniawan",
    mapel: ["Biologi"],
    maxJamPerHari: 3,
    preferensiHari: ["Rabu", "Jumat"],
    hariTidakBisa: [],
  ),
  Teacher(
    id: 7,
    nama: "Agus Priyanto",
    mapel: ["Sejarah"],
    maxJamPerHari: 3,
    preferensiHari: ["Senin", "Kamis"],
    hariTidakBisa: [],
  ),
];
