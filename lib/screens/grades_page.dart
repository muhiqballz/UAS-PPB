import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/grade_model.dart';

class GradesPage extends StatefulWidget {
  final String userId;
  const GradesPage({Key? key, this.userId = '1'}) : super(key: key);

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  late Future<List<GradeModel>> _futureGrades;

  @override
  void initState() {
    super.initState();
    _futureGrades = fetchGrades();
  }

  Future<List<GradeModel>> fetchGrades() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/grades.php');
    final response = await http.post(url, body: {'user_id': widget.userId});

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((e) => GradeModel.fromJson(e)).toList();
      }
    }
    throw Exception('Gagal memuat nilai');
  }

  double _calculateIPS(List<GradeModel> grades) {
    double totalBobot = 0;
    int totalSks = 0;

    for (var item in grades) {
      double bobot = 0;
      switch (item.grade) {
        case 'A': bobot = 4.0; break;
        case 'B': bobot = 3.0; break;
        case 'C': bobot = 2.0; break;
        case 'D': bobot = 1.0; break;
        default: bobot = 0.0;
      }
      totalBobot += (bobot * item.sks);
      totalSks += item.sks;
    }

    if (totalSks == 0) return 0.0;
    return totalBobot / totalSks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF0F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        title: const Text('Nilai Semester', style: TextStyle(color: Color(0xFFECF0F1))),
      ),
      body: FutureBuilder<List<GradeModel>>(
        future: _futureGrades,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final grades = snapshot.data!;
            final ips = _calculateIPS(grades); 

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C3E50),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text('Indeks Prestasi Semester (IPS)', style: TextStyle(color: Color(0xB3ECF0F1), fontSize: 14)),
                      const SizedBox(height: 8),
                      Text(
                        ips.toStringAsFixed(2), 
                        style: const TextStyle(color: Color(0xFF2ECC71), fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Total SKS: ${grades.fold(0, (sum, item) => sum + item.sks)}', style: const TextStyle(color: Color(0xFFECF0F1))),
                    ],
                  ),
                ),

                Expanded(
                  child: grades.isEmpty 
                  ? const Center(child: Text("Belum ada data nilai."))
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: grades.length,
                    itemBuilder: (context, index) {
                      return _buildGradeCard(grades[index]);
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text("Tidak ada data."));
        },
      ),
    );
  }

  Widget _buildGradeCard(GradeModel item) {
    final statusColor = item.isPassed ? const Color(0xFF27AE60) : const Color(0xFFE74C3C);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.subject, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                const SizedBox(height: 4),
                Text('${item.sks} SKS', style: TextStyle(fontSize: 12, color: const Color(0xFF2C3E50).withOpacity(0.6))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _scoreBadge('Tugas', item.taskScore),
                    const SizedBox(width: 8),
                    _scoreBadge('UTS', item.midScore),
                    const SizedBox(width: 8),
                    _scoreBadge('UAS', item.finalScore),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                Text(item.grade, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: statusColor)),
                Text(item.isPassed ? 'Lulus' : 'Gagal', style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreBadge(String label, double score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(score.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
      ],
    );
  }
}