import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/profile_model.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  final String userName;
  final String userNim;

  const ProfilePage({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userNim,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;

  late Future<ProfileModel> _futureProfile;

  @override
  void initState() {
    super.initState();
    _futureProfile = fetchProfile();
  }

  Future<ProfileModel> fetchProfile() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/profile.php');
    final response = await http.post(url, body: {'user_id': widget.userId});

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        return ProfileModel.fromJson(jsonResponse['data']);
      }
    }
    throw Exception('Gagal memuat profil');
  }

  Widget _buildContent(ProfileModel profile) {
    switch (_selectedIndex) {
      case 0:
        return _buildBiodataSection(profile.biodata);
      case 1:
        return _buildAkademikSection(profile.akademik);
      case 2:
        return _buildRegistrasiSection(profile.registrasi);
      case 3:
        return _buildKurikulumSection(profile.kurikulum);
      case 4:
        return _buildKrsSection(profile.krs);
      default:
        return Container();
    }
  }

  Widget _buildBiodataSection(Biodata data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data Diri Mahasiswa',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50)),
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Nama', data.nama),
          _buildDetailRow('NIM', data.nim),
          _buildDetailRow(
              'Jenis Kelamin', data.gender == 'L' ? 'Laki-laki' : 'Perempuan'),
          _buildDetailRow('Tgl Lahir', data.tglLahir),
          _buildDetailRow('Alamat', data.alamat),
          _buildDetailRow('No HP', data.hp),
        ],
      ),
    );
  }

  Widget _buildAkademikSection(List<AkademikItem> data) {
    if (data.isEmpty)
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("Belum ada data nilai.")));

    Map<String, List<AkademikItem>> groupedData = {};
    for (var item in data) {
      if (!groupedData.containsKey(item.semester)) {
        groupedData[item.semester] = [];
      }
      groupedData[item.semester]!.add(item);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Akademik',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50)),
          ),
          const SizedBox(height: 12),

          ...groupedData.entries.map((entry) {
            String semester = entry.key;
            List<AkademikItem> matkulList = entry.value;

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                initiallyExpanded:
                    semester == '5',
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Semester $semester',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3498DB)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: const Color(0xFF27AE60).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('${matkulList.length} Matkul',
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF27AE60),
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                children: matkulList.map((item) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: Colors.grey.withOpacity(0.1)))),
                    child: _buildCourseCard(
                      item.nama,
                      item.kode,
                      'Nilai Akhir',
                      item.grade,
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRegistrasiSection(List<RegistrasiItem> data) {
    if (data.isEmpty)
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("Belum ada data registrasi.")));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Registrasi',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50)),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor:
                  MaterialStateProperty.all(const Color(0xFFF0F4F7)),
              columns: const [
                DataColumn(label: Text('Smt')),
                DataColumn(label: Text('Jumlah')),
                DataColumn(label: Text('Tgl Bayar')),
                DataColumn(label: Text('Status')),
              ],
              rows: data.map<DataRow>((reg) {
                return DataRow(
                  cells: [
                    DataCell(Text(reg.semester)),
                    DataCell(Text(reg.jumlah)),
                    DataCell(Text(reg.tanggal)),
                    DataCell(Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color:
                              reg.status == 'Lunas' ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(reg.status,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10)),
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKurikulumSection(List<KurikulumItem> data) {
    if (data.isEmpty)
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("Data kurikulum kosong.")));

    Map<String, List<KurikulumItem>> groupedData = {};
    for (var item in data) {
      if (!groupedData.containsKey(item.semester)) {
        groupedData[item.semester] = [];
      }
      groupedData[item.semester]!.add(item);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daftar Kurikulum',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50)),
          ),
          const SizedBox(height: 12),

          ...groupedData.entries.map((entry) {
            String semester = entry.key;
            List<KurikulumItem> matkulList = entry.value;

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  'Semester $semester',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3498DB)),
                ),
                children: matkulList.map((item) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: Colors.grey.withOpacity(0.1)))),
                    child: _buildCourseCard(
                      item.nama,
                      item.kode,
                      '${item.sks} SKS',
                      'Wajib',
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildKrsSection(List<KrsItem> data) {
    if (data.isEmpty)
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(20), child: Text("Belum ada KRS.")));

    Map<String, List<KrsItem>> groupedData = {};
    for (var item in data) {
      if (!groupedData.containsKey(item.semester)) {
        groupedData[item.semester] = [];
      }
      groupedData[item.semester]!.add(item);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat KRS',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50)),
          ),
          const SizedBox(height: 12),

          ...groupedData.entries.map((entry) {
            String semester = entry.key;
            List<KrsItem> krsList = entry.value;

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                initiallyExpanded: semester == '5',
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  'Semester $semester',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3498DB)),
                ),
                children: krsList.map((krs) {
                  Color statusColor = (krs.status == 'Disetujui')
                      ? const Color(0xFF27AE60)
                      : (krs.status == 'Pending'
                          ? const Color(0xFFE67E22)
                          : const Color(0xFFE74C3C));

                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: Colors.grey.withOpacity(0.1)))),
                    child: _buildKrsCardInternal(krs.nama, krs.hari,
                        '${krs.sks} SKS', krs.status, statusColor),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildKrsCardInternal(String subject, String time, String info,
      String status, Color statusColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(subject,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50))),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time,
                    size: 14, color: Color(0xFF3498DB)),
                const SizedBox(width: 4),
                Text(time,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF2C3E50))),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                  color: statusColor, borderRadius: BorderRadius.circular(4)),
              child: Text(status,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKrsCard(String subject, String time, String info, String status,
      Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0xFFE0E0E0),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subject,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50))),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Color(0xFF3498DB)),
              const SizedBox(width: 8),
              Text(time,
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF2C3E50))),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: statusColor, borderRadius: BorderRadius.circular(6)),
            child: Text(status,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 120,
              child: Text('$label:',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)))),
          Expanded(
              child: Text(value,
                  style: const TextStyle(color: Color(0xFF2C3E50)))),
        ],
      ),
    );
  }

  Widget _buildProfileButton(int index, String label, IconData icon) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3498DB) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: isSelected ? Colors.white : const Color(0xFF2C3E50),
                size: 24),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    color: isSelected ? Colors.white : const Color(0xFF2C3E50),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(
      String courseName, String courseCode, String info1, String info2) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          color: const Color(0xFFF0F4F7),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(courseName,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50))),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(courseCode,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF2C3E50))),
              Text(info1,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF2C3E50))),
            ],
          ),
          const SizedBox(height: 4),
          Text(info2,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF27AE60))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF0F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        title: const Text('Profil', style: TextStyle(color: Color(0xFFECF0F1))),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFECF0F1)),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<ProfileModel>(
        future: _futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final profile = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2C3E50),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('lib/assets/images/bale.jpg'),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profile.biodata.nama,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFECF0F1)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.biodata.nim,
                          style: const TextStyle(
                              fontSize: 16, color: Color(0xFFECF0F1)),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xFFE0E0E0),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2))
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildProfileButton(0, 'Biodata', Icons.person),
                        _buildProfileButton(1, 'Akademik', Icons.school),
                        _buildProfileButton(2, 'Registrasi', Icons.payment),
                        _buildProfileButton(3, 'Kurikulum', Icons.menu_book),
                        _buildProfileButton(4, 'KRS', Icons.assignment),
                      ],
                    ),
                  ),

                  _buildContent(profile),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
          return const Center(child: Text("Tidak ada data user."));
        },
      ),
    );
  }
}