import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';


@JsonSerializable()
class Note {
  late int id;
  late String content;
  
  
  Note(
      {required this.id,
      required this.content,
   
      });
  Note.defaultConstructor();

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);

}
