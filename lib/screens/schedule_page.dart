import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/schedule_model.dart';

class SchedulePage extends StatefulWidget {
  final String userId;

  const SchedulePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late Future<Map<String, List<ScheduleItem>>> _futureSchedule;

  @override
  void initState() {
    super.initState();
    _futureSchedule = fetchSchedules();
  }

  Future<Map<String, List<ScheduleItem>>> fetchSchedules() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/schedule.php');
    final response = await http.post(url, body: {'user_id': widget.userId});

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      
      if (jsonResponse['success'] == true) {
        final List<dynamic> data = jsonResponse['data'];
        List<ScheduleItem> allSchedules = data.map((e) => ScheduleItem.fromJson(e)).toList();

        Map<String, List<ScheduleItem>> grouped = {
          'Senin': [],
          'Selasa': [],
          'Rabu': [],
          'Kamis': [],
          'Jumat': [],
          'Sabtu': [],
        };

        for (var item in allSchedules) {
          if (grouped.containsKey(item.day)) {
            grouped[item.day]!.add(item);
          }
        }
        return grouped;
      }
    }
    throw Exception('Gagal memuat jadwal');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF0F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        title: const Text('Jadwal Kuliah', style: TextStyle(color: Color(0xFFECF0F1))),
      ),
      body: FutureBuilder<Map<String, List<ScheduleItem>>>(
        future: _futureSchedule,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final scheduleData = snapshot.data!;
            
            bool isEmpty = scheduleData.values.every((list) => list.isEmpty);
            if (isEmpty) {
              return const Center(child: Text("Belum ada jadwal kuliah yang diambil."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: scheduleData.length,
              itemBuilder: (context, index) {
                String day = scheduleData.keys.elementAt(index);
                List<ScheduleItem> classes = scheduleData[day]!;

                if (classes.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 4, height: 24,
                            decoration: BoxDecoration(color: const Color(0xFF3498DB), borderRadius: BorderRadius.circular(2)),
                          ),
                          const SizedBox(width: 12),
                          Text(day, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                        ],
                      ),
                    ),
                    ...classes.map((item) => _buildScheduleCard(item)),
                    const SizedBox(height: 8),
                  ],
                );
              },
            );
          }
          return const Center(child: Text("Tidak ada data."));
        },
      ),
    );
  }

  Widget _buildScheduleCard(ScheduleItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.subject, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Color(0xFF3498DB)),
              const SizedBox(width: 8),
              Text(item.time, style: TextStyle(fontSize: 14, color: const Color(0xFF2C3E50).withOpacity(0.7))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.room, size: 16, color: Color(0xFF3498DB)),
              const SizedBox(width: 8),
              Text(item.room, style: TextStyle(fontSize: 14, color: const Color(0xFF2C3E50).withOpacity(0.7))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: Color(0xFF3498DB)),
              const SizedBox(width: 8),
              Expanded(child: Text(item.lecturer, style: TextStyle(fontSize: 14, color: const Color(0xFF2C3E50).withOpacity(0.7)))),
            ],
          ),
        ],
      ),
    );
  }
}