import 'package:json_annotation/json_annotation.dart';

// part 'quiz.g.dart';


// @JsonSerializable()
// class Quiz {
//   late int id;
//   late String title;
//   late String description;

//   Quiz({
//     required this.id,
//     required this.title,
//     required this.description,
//   });

//   Quiz.defaultConstructor();

//   factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
//   Map<String, dynamic> toJson() => _$QuizToJson(this);
// }


class Quiz {
  final String id;
  final String title;
  final String description;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'].toString(),
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}
