# TODO - Eduschedule (penyesuaian kebutuhan sekolah umum Indonesia)

## Plan yang akan dikerjakan

### 1) Perbaiki GA supaya constraint UI benar-benar dipakai

- [ ] Update `runGeneticAlgorithm` agar menerima `Constraints constraints`
- [ ] Implement fitness untuk:
  - [ ] guru no bentrok (bentrok slot)
  - [ ] kelas no bentrok (bentrok slot)
  - [ ] ruang no bentrok (bentrok slot)
  - [ ] preferensi hari guru
  - [ ] `Teacher.maxJamPerHari`
  - [ ] minim jam kosong (gap) per kelas per hari
  - [ ] (jika perlu) max mapel berturut-turut & berat per hari sesuai data yang tersedia
- [ ] Pastikan toggles `Constraints` benar-benar mengaktifkan/menonaktifkan rule

### 2) Ubah tampilan hasil menjadi tabel jadwal (jam sebagai kolom) per kelas

- [ ] Tambahkan mode tampilan default: “Tabel per Kelas”
- [ ] Definisikan header slot waktu dari `generateTimeSlots(school)`
- [ ] Implement render grid: baris = hari, kolom = slot
- [ ] Isi cell: mapel + guru + ruang (atau minimal mapel, lalu detail via tooltip/card)
- [ ] Pastikan filter kelas/guru/hari tetap berfungsi

### 3) Bonus: Auto Tambah Mapel Wajib untuk jenjang SD/SMP/SMA

- [ ] Tambahkan tombol di FormMapel: “Auto Tambah Mapel Wajib”
- [ ] Map pelajaran wajib dari `SchoolLevel.coreSubjects`
- [ ] Isi awal `jamPerMinggu` default (sementara) atau allow override manual
- [ ] Pastikan kelas/rombel yang dipilih menjadi target subject

## Setelah itu

- [ ] Jalankan `flutter analyze`
- [ ] Jalankan build web (opsional) `flutter build web`
