import 'package:flutter/material.dart';

class MaterialDetailPage extends StatefulWidget {
  final String courseName;
  final List<String> materials;
  final List<Map<String, dynamic>> videos;
  final List<Map<String, dynamic>> assignments;
  final Color color;

  const MaterialDetailPage({
    Key? key,
    required this.courseName,
    required this.materials,
    required this.videos, 
    required this.assignments,
    required this.color,
  }) : super(key: key);

  @override
  State<MaterialDetailPage> createState() => _MaterialDetailPageState();
}

class _MaterialDetailPageState extends State<MaterialDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF0F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFECF0F1)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.courseName,
          style: const TextStyle(color: Color(0xFFECF0F1)),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF3498DB),
          unselectedLabelColor: const Color(0xFFECF0F1).withOpacity(0.6),
          indicatorColor: const Color(0xFF3498DB),
          tabs: const [
            Tab(text: 'Materi'),
            Tab(text: 'Penugasan'),
            Tab(text: 'Video'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMaterialsTab(),
          _buildAssignmentsTab(),
          _buildVideosTab(),
        ],
      ),
    );
  }

  Widget _buildMaterialsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.materials.length,
      itemBuilder: (context, index) {
        String fileName = widget.materials[index];
        String fileExtension = fileName.split('.').last.toUpperCase();

        return _buildMaterialCard(fileName, fileExtension);
      },
    );
  }

  Widget _buildAssignmentsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.assignments.length,
      itemBuilder: (context, index) {
        final assignment = widget.assignments[index];
        return _buildAssignmentCard(
          assignment['title'],
          assignment['dueDate'],
          assignment['status'],
        );
      },
    );
  }

  Widget _buildVideosTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.videos.length,
      itemBuilder: (context, index) {
        final video = widget.videos[index];
        return _buildVideoCard(
          video['title'],
          video['duration'],
        );
      },
    );
  }

  Widget _buildMaterialCard(String fileName, String fileExtension) {
    IconData fileIcon;
    Color iconColor;

    switch (fileExtension) {
      case 'PDF':
        fileIcon = Icons.picture_as_pdf;
        iconColor = const Color(0xFFE74C3C);
        break;
      case 'PPTX':
      case 'PPT':
        fileIcon = Icons.slideshow;
        iconColor = const Color(0xFFE67E22);
        break;
      case 'DOCX':
      case 'DOC':
        fileIcon = Icons.description;
        iconColor = const Color(0xFF3498DB);
        break;
      case 'ZIP':
        fileIcon = Icons.folder_zip;
        iconColor = const Color(0xFF95A5A6);
        break;
      default:
        fileIcon = Icons.insert_drive_file;
        iconColor = const Color(0xFF7F8C8D);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              fileIcon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fileExtension,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF2C3E50).withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.download,
              color: widget.color,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(String title, String dueDate, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF9B59B6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.assignment,
              color: Color(0xFF9B59B6),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dueDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF2C3E50).withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: status == 'Belum Dikumpulkan'
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Upload',
              style: TextStyle(
                color: widget.color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(String title, String duration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF3498DB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.play_circle_fill,
              color: Color(0xFF3498DB),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  duration,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF2C3E50).withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Tonton',
              style: TextStyle(
                color: widget.color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}