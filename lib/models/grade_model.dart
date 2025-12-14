class GradeModel {
  final String subject;
  final int sks;
  final double taskScore;
  final double midScore;
  final double finalScore;
  final String grade; // A, B, C, D, E
  final bool isPassed;

  GradeModel({
    required this.subject,
    required this.sks,
    required this.taskScore,
    required this.midScore,
    required this.finalScore,
    required this.grade,
    required this.isPassed,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      subject: json['subject'],
      sks: json['sks'],
      taskScore: (json['taskScore'] as num).toDouble(),
      midScore: (json['midScore'] as num).toDouble(),
      finalScore: (json['finalScore'] as num).toDouble(),
      grade: json['grade'],
      isPassed: json['isPassed'],
    );
  }
}