StudyMate: Mobile Learning Management System (LMS)
Proyek Ujian Akhir Semester (UAS) Mata Kuliah Pemrograman Perangkat Bergerak (PPB)
Kelas: 5B - Sistem Informasi Kelompok: 3

Anggota:
1. Asep Imam Wahyudi	(2310631250006)
2. Muhammad Iqbal Pratama	(2310631250097)
3. Dhafa Fikriansyiah Putra	(2310631250012)

📄 Deskripsi Proyek dan Arsitektur Sistem
StudyMate adalah aplikasi Learning Management System (LMS) berbasis mobile native yang dikembangkan menggunakan Flutter. Proyek ini bertujuan untuk menyediakan akses cepat, terpusat, dan real-time terhadap informasi akademik mahasiswa, mengatasi keterbatasan akses sistem berbasis web konvensional pada perangkat seluler.

Fokus Pengembangan UAS (Statis ke Dinamis)
Fase pengembangan proyek UAS ini berfokus pada transformasi total dari prototipe statis (yang datanya masih tertanam dalam kode program) menjadi sistem dinamis yang sepenuhnya terintegrasi dengan server.

Arsitektur Sistem
StudyMate menerapkan Arsitektur 3-Lapisan (3-Tier Architecture) untuk memisahkan tanggung jawab antara tampilan, logika bisnis, dan penyimpanan data, memastikan sistem berjalan secara efisien dan terstruktur.
1. Lapisan Presentasi (Frontend): Dibuat menggunakan Flutter dan Dart, yang bertanggung jawab atas seluruh antarmuka pengguna (User Interface) dan pengalaman pengguna (User Experience). Lapisan ini mengirimkan permintaan data (Request) dan menampilkan hasil respons (JSON) dari server.
2. Lapisan Logika Bisnis (Backend/API): Berfungsi sebagai jembatan yang memproses permintaan dari Flutter. Lapisan ini dikembangkan sebagai REST API menggunakan PHP Native. Tugas utamanya adalah melakukan validasi data, menjalankan query ke database, dan mengonversi hasil data SQL menjadi format JSON yang siap dikonsumsi oleh aplikasi mobile.
3. Lapisan Data (Database): Menggunakan MySQL (di-host melalui XAMPP) sebagai pusat penyimpanan data relasional. Lapisan ini menyimpan semua data akademik, mulai dari profil mahasiswa, jadwal, nilai, hingga materi.

Fitur Fungsionalitas Dinamis
Seluruh fitur utama aplikasi StudyMate kini mengambil dan memproses data secara langsung dari database MySQL melalui API:
1. Autentikasi: Fitur Login telah diimplementasikan dengan validasi username (NIM) dan password yang dicocokkan langsung dengan tabel users di database.
2. Dashboard: Menampilkan sapaan personal pengguna, pengumuman terkini, dan jadwal kuliah yang difilter secara otomatis hanya untuk Hari Ini (berdasarkan tanggal sistem).
3. Jadwal Kuliah: Menampilkan daftar mata kuliah yang diambil mahasiswa pada Semester Aktif (difilter hanya Semester 5), disusun berdasarkan hari dan jam, dengan status persetujuan KRS yang terperiksa.
4. Materi & Tugas: Mengambil daftar mata kuliah Semester 5, menampilkan file materi yang diunggah, serta link video pembelajaran dan status penugasan yang relevan dengan mata kuliah tersebut.
5. Profil Mahasiswa: Bagian ini menyajikan data lengkap secara terstruktur (dikelompokkan per semester) yang meliputi: Biodata Diri, Riwayat Registrasi Pembayaran, Riwayat Akademik (KHS/Nilai), Riwayat Kartu Rencana Studi (KRS), dan Daftar Kurikulum.

🛠️ Panduan Instalasi (Lokal)
Untuk menjalankan proyek ini, perlu melakukan setup lingkungan server lokal:
1. Setup API (PHP): Salin folder studymate_api (berisi semua file PHP) ke dalam direktori C:\xampp\htdocs\.
2. Setup Database: Impor skema dan data dummy yang tersedia ke MySQL (melalui phpMyAdmin) dengan nama database studymate.
3. Konfigurasi Flutter: Buka file api_config.dart dan pastikan Anda mengatur base URL ke IP lokal komputer Anda (misalnya http://192.168.x.x/studymate_api).
4. Jalankan: Pastikan server Apache dan MySQL di XAMPP berjalan, lalu jalankan aplikasi Flutter di emulator atau perangkat fisik yang terhubung ke jaringan lokal yang sama.
