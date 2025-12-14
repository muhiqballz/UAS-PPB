class ScheduleItem {
  final String day;
  final String subject;
  final String time;
  final String room;
  final String lecturer;

  ScheduleItem({
    required this.day,
    required this.subject,
    required this.time,
    required this.room,
    required this.lecturer,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      day: json['day'],
      subject: json['subject'],
      time: json['time'],
      room: json['room'],
      lecturer: json['lecturer'],
    );
  }
}