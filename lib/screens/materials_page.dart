import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/course_model.dart';
import 'material_detail_page.dart';

class MaterialsPage extends StatefulWidget {
  final String userId;

  const MaterialsPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  late Future<List<CourseModel>> _futureCourses;

  @override
  void initState() {
    super.initState();
    _futureCourses = fetchCourses();
  }

  Future<List<CourseModel>> fetchCourses() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/materials.php');
    
    final response = await http.post(url, body: {'user_id': widget.userId}); 

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((e) => CourseModel.fromJson(e)).toList();
      }
    }
    throw Exception('Gagal memuat materi');
  }

  Color _parseColor(String hexColorString) {
    try {
      return Color(int.parse(hexColorString));
    } catch (e) {
      return const Color(0xFF3498DB);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF0F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        title: const Text('Materi Kuliah', style: TextStyle(color: Color(0xFFECF0F1))),
      ),
      body: FutureBuilder<List<CourseModel>>(
        future: _futureCourses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final courses = snapshot.data!;
            
            if (courses.isEmpty) {
              return const Center(child: Text("Belum ada materi kuliah."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return _buildCourseCard(context, course);
              },
            );
          }
          return const Center(child: Text("Tidak ada data."));
        },
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, CourseModel course) {
    final color = _parseColor(course.color);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MaterialDetailPage(
                courseName: course.name,
                materials: course.materials.map((e) => e.title).toList(), 
                videos: course.videos.map((e) => {
                  'title': e.title,
                  'duration': e.duration
                }).toList(),
                assignments: course.assignments.map((e) => {
                  'title': e.title,
                  'dueDate': e.dueDate,
                  'status': e.status
                }).toList(),
                color: color,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.book, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                    const SizedBox(height: 6),
                    Text(
                      '${course.materials.length} Materi • ${course.videos.length} Video',
                      style: TextStyle(fontSize: 13, color: const Color(0xFF2C3E50).withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: const Color(0xFF2C3E50).withOpacity(0.3), size: 18),
            ],
          ),
        ),
      ),
    );
  }
}