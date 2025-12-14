class CourseModel {
  final String name;
  final String icon; 
  final String color; 
  final List<MaterialItem> materials;
  final List<VideoItem> videos;
  final List<AssignmentItem> assignments;

  CourseModel({
    required this.name,
    required this.icon,
    required this.color,
    required this.materials,
    required this.videos,
    required this.assignments,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      name: json['name'],
      icon: json['icon'] ?? 'book',
      color: json['color'] ?? '0xFF3498DB',
      materials: (json['materials'] as List? ?? [])
          .map((e) => MaterialItem.fromJson(e))
          .toList(),
      videos: (json['videos'] as List? ?? [])
          .map((e) => VideoItem.fromJson(e))
          .toList(),
      assignments: (json['assignments'] as List? ?? [])
          .map((e) => AssignmentItem.fromJson(e))
          .toList(),
    );
  }
}

class MaterialItem {
  final String title;
  final String type;
  final String filePath;

  MaterialItem({required this.title, required this.type, required this.filePath});

  factory MaterialItem.fromJson(Map<String, dynamic> json) {
    return MaterialItem(
      title: json['judul_materi'],
      type: json['jenis_file'],
      filePath: json['file_path'],
    );
  }
}

class VideoItem {
  final String title;
  final String duration;
  final String url;

  VideoItem({required this.title, required this.duration, required this.url});

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      title: json['judul_video'],
      duration: json['durasi'],
      url: json['url_video'],
    );
  }
}

class AssignmentItem {
  final String title;
  final String dueDate;
  final String status;

  AssignmentItem({required this.title, required this.dueDate, required this.status});

  factory AssignmentItem.fromJson(Map<String, dynamic> json) {
    return AssignmentItem(
      title: json['title'],
      dueDate: json['dueDate'],
      status: json['status'],
    );
  }
}