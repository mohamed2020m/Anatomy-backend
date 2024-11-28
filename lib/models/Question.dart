import 'package:json_annotation/json_annotation.dart';


class Question {
  final int id;
  final String questionText;
  final Map<String, String> options;
  final String correctAnswer;
  final String explanation;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  // factory Question.fromJson(Map<String, dynamic> json) {
  //   return Question(
  //     id: json['id'].toString(),
  //     questionText: json['questionText'] as String,
  //     options: json['options'] as Map<String, String>,
  //     correctAnswer: json['correctAnswer'] as String,
  //     explanation: json['explanation'] as String,
  //   );
  // }

  // Factory constructor to create a Question from a JSON map
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      questionText: json['questionText'] as String,
      options: Map<String, String>.from(json['options'] as Map),
      correctAnswer: json['correctAnswer'] as String,
      explanation: json['explanation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionText': questionText,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }
}
