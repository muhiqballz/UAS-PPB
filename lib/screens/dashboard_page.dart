import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/dashboard_data.dart';
import 'notification_popup.dart';
import '../config/api_config.dart';

class DashboardPage extends StatefulWidget {
  final String userId;
  final String userName;
  final Function(int) onQuickAccessTap;

  const DashboardPage({
    Key? key,
    required this.userId,
    required this.userName,
    required this.onQuickAccessTap,
  }) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<DashboardData> _futureDashboard;

  @override
  void initState() {
    super.initState();
    _futureDashboard = fetchDashboardData();
  }

  Future<DashboardData> fetchDashboardData() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/dashboard.php');
    
    final response = await http.post(url, body: {'user_id': widget.userId});

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return DashboardData.fromJson(jsonResponse);
    } else {
      throw Exception('Gagal memuat data: ${response.statusCode}');
    }
  }

  Color _parseColor(String hexColorString) {
    try {
      return Color(int.parse(hexColorString));
    } catch (e) {
      return Colors.blue; 
    }
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'payment': return Icons.payment;
      case 'campaign': return Icons.campaign;
      case 'library': return Icons.local_library;
      case 'notifications': return Icons.notifications;
      default: return Icons.info;
    }
  }

  final List<Map<String, dynamic>> _notifications = const [
    {
      'title': 'Tugas Baru',
      'message': 'Silakan kerjakan tugas Pemrograman Perangkat Bergerak.',
      'icon': Icons.grade,
      'color': Color(0xFFE67E22),
    },
    {
      'title': 'Pengumuman',
      'message': 'Kuliah besok dimulai pukul 09:00',
      'icon': Icons.announcement,
      'color': Color(0xFFE74C3C),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF0F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        title: const Text('Dashboard', style: TextStyle(color: Color(0xFFECF0F1))),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Color(0xFFECF0F1)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => NotificationPopup(notifications: _notifications),
                  );
                },
              ),
              Positioned(
                right: 8, top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Color(0xFFE74C3C), shape: BoxShape.circle),
                  child: Text('${_notifications.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<DashboardData>(
        future: _futureDashboard,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
              ),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2C3E50),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Halo, ${widget.userName}!', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFECF0F1))),
                        const SizedBox(height: 8),
                        const Text('Selamat datang kembali', style: TextStyle(fontSize: 14, color: Color(0xB3ECF0F1))),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jadwal Hari Ini (${data.hariIni})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                        const SizedBox(height: 12),
                        
                        if (data.schedule.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                            child: const Text("Tidak ada jadwal kuliah hari ini.", style: TextStyle(color: Colors.grey)),
                          )
                        else
                          ...data.schedule.map((item) => _buildScheduleCard(
                            item.subject,
                            item.time,
                            item.room,
                            Icons.class_,
                            item.lecturer
                          )),

                        const SizedBox(height: 24),

                        const Text('Informasi Terkini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                        const SizedBox(height: 12),
                        
                        ...data.info.map((info) => _buildInfoCard(
                          info.title,
                          info.message,
                          _getIcon(info.icon),
                          _parseColor(info.color),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text("Tidak ada data."));
        },
      ),
    );
  }

  Widget _buildScheduleCard(String subject, String time, String room, IconData icon, String lecturer) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF3498DB).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: const Color(0xFF3498DB), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                const SizedBox(height: 4),
                Text(time, style: TextStyle(fontSize: 14, color: const Color(0xFF2C3E50).withOpacity(0.6))),
                Text('$room • $lecturer', style: TextStyle(fontSize: 12, color: const Color(0xFF2C3E50).withOpacity(0.4))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String message, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                const SizedBox(height: 4),
                Text(message, style: TextStyle(fontSize: 12, color: const Color(0xFF2C3E50).withOpacity(0.6))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}