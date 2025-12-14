class ProfileModel {
  final Biodata biodata;
  final List<RegistrasiItem> registrasi;
  final List<KurikulumItem> kurikulum;
  final List<KrsItem> krs;
  final List<AkademikItem> akademik;

  ProfileModel({
    required this.biodata,
    required this.registrasi,
    required this.kurikulum,
    required this.krs,
    required this.akademik,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      biodata: Biodata.fromJson(json['biodata']),
      registrasi: (json['registrasi'] as List).map((e) => RegistrasiItem.fromJson(e)).toList(),
      kurikulum: (json['kurikulum'] as List).map((e) => KurikulumItem.fromJson(e)).toList(),
      krs: (json['krs'] as List).map((e) => KrsItem.fromJson(e)).toList(),
      akademik: (json['akademik'] as List).map((e) => AkademikItem.fromJson(e)).toList(),
    );
  }
}

class Biodata {
  final String nama;
  final String nim;
  final String hp;
  final String alamat;
  final String tglLahir;
  final String gender;

  Biodata({required this.nama, required this.nim, required this.hp, required this.alamat, required this.tglLahir, required this.gender});

  factory Biodata.fromJson(Map<String, dynamic> json) {
    return Biodata(
      nama: json['nama_lengkap'],
      nim: json['nim'],
      hp: json['no_hp'],
      alamat: json['alamat'],
      tglLahir: json['tanggal_lahir'],
      gender: json['jenis_kelamin'],
    );
  }
}

class RegistrasiItem {
  final String semester;
  final String jumlah;
  final String tanggal;
  final String status;

  RegistrasiItem({required this.semester, required this.jumlah, required this.tanggal, required this.status});

  factory RegistrasiItem.fromJson(Map<String, dynamic> json) {
    return RegistrasiItem(
      semester: json['semester'],
      jumlah: json['jumlah_bayar'],
      tanggal: json['tanggal_bayar'] ?? '-',
      status: json['status_lunas'] == '1' ? 'Lunas' : 'Belum Lunas',
    );
  }
}

class KurikulumItem {
  final String kode;
  final String nama;
  final String sks;
  final String semester;

  KurikulumItem({required this.kode, required this.nama, required this.sks, required this.semester});

  factory KurikulumItem.fromJson(Map<String, dynamic> json) {
    return KurikulumItem(
      kode: json['kode_mk'],
      nama: json['nama_mk'],
      sks: json['sks'],
      semester: json['semester_paket'],
    );
  }
}

class KrsItem {
  final String kode;
  final String nama;
  final String sks;
  final String hari;
  final String status;
  final String semester; 

  KrsItem({
    required this.kode, 
    required this.nama, 
    required this.sks, 
    required this.hari,
    required this.status,
    required this.semester, 
  });

  factory KrsItem.fromJson(Map<String, dynamic> json) {
    return KrsItem(
      kode: json['kode_mk'],
      nama: json['nama_mk'],
      sks: json['sks'],
      hari: json['hari'],
      status: json['status_persetujuan'] ?? 'Pending',
      semester: json['semester_ambil'] ?? '0', 
    );
  }
}

class AkademikItem {
  final String kode;
  final String nama;
  final String grade;
  final String semester; 

  AkademikItem({
    required this.kode, 
    required this.nama, 
    required this.grade,
    required this.semester, 
  });

  factory AkademikItem.fromJson(Map<String, dynamic> json) {
    return AkademikItem(
      kode: json['kode_mk'],
      nama: json['nama_mk'],
      grade: json['grade_huruf'] ?? '-',
      semester: json['semester_ambil'] ?? '0', 
    );
  }
}