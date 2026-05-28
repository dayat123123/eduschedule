# TODO

## Subclass per Mapel + validasi step

- [x] Update `FormMapel` UI: tambahkan tombol "Tambah Subclass" yang benar per mapel, per section kelas, dan simpan ke `Subject.subclassesBySection`.
- [ ] Sinkronkan `m.kelas` (MultiSelect) dengan `subclassesBySection` (hapus key yang tidak dipilih, buat key baru kalau ada).
- [ ] Perbaiki inisialisasi `Subject` saat ditambah di `FormMapel.add()` agar `subclassesBySection` siap sesuai section kelas.
- [ ] Update validasi perpindahan step di `FormScreen`: langkah Mapel tidak boleh nge-block navigasi ke step lain jika mapel masih kosong (tapi Generate tetap memvalidasi semuanya).

- [ ] Jalankan `flutter analyze` dan `flutter run` untuk memastikan tidak ada error.
