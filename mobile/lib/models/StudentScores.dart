
class StudentScores {
  final int studentId;
  final int quizId;
  final double score;

  StudentScores({
    required this.studentId,
    required this.quizId,
    required this.score,
  });

  factory StudentScores.fromJson(Map<String, dynamic> json) {
    return StudentScores(
      studentId: json['studentId'] as int,
      quizId: json['quizId'] as int,
      score: json['score'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'quizId': quizId,
      'score': score,
    };
  }
}
