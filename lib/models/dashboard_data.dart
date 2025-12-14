class DashboardData {
  final bool success;
  final String hariIni;
  final List<JadwalItem> schedule;
  final List<InfoItem> info;

  DashboardData({
    required this.success,
    required this.hariIni,
    required this.schedule,
    required this.info,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      success: json['success'],
      hariIni: json['hari_ini'],
      schedule: (json['schedule'] as List)
          .map((item) => JadwalItem.fromJson(item))
          .toList(),
      info: (json['info'] as List)
          .map((item) => InfoItem.fromJson(item))
          .toList(),
    );
  }
}

class JadwalItem {
  final String subject;
  final String time;
  final String room;
  final String lecturer;

  JadwalItem({
    required this.subject,
    required this.time,
    required this.room,
    required this.lecturer,
  });

  factory JadwalItem.fromJson(Map<String, dynamic> json) {
    return JadwalItem(
      subject: json['subject'],
      time: json['time'],
      room: json['room'],
      lecturer: json['lecturer'],
    );
  }
}

class InfoItem {
  final String title;
  final String message;
  final String icon;
  final String color;

  InfoItem({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
  });

  factory InfoItem.fromJson(Map<String, dynamic> json) {
    return InfoItem(
      title: json['title'],
      message: json['message'],
      icon: json['icon'],
      color: json['color'],
    );
  }
}
