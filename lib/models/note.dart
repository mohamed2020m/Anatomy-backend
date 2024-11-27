// import 'package:TerraViva/models/ThreeDObject.dart';
// import 'package:TerraViva/models/user.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'note.g.dart';

// @JsonSerializable()
// class Note {
//   late int id;
//   late String content;


//   Note({
//     required this.id,
//     required this.content,
//   });
//   Note.defaultConstructor();

//   factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
//   Map<String, dynamic> toJson() => _$NoteToJson(this);
// }


import 'package:TerraViva/models/ThreeDObject.dart';
import 'package:TerraViva/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  late int id;
  late String content;
  late ThreeDObject threeDObject;

  Note({
    required this.id,
    required this.content,
    required this.threeDObject,
  });

  // Default constructor for optional initialization
  Note.defaultConstructor();

  // Factory method for JSON serialization/deserialization
  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
