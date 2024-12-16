import 'package:json_annotation/json_annotation.dart';

part 'ThreeDObject.g.dart';

@JsonSerializable()
class ThreeDObject {
  late int id;
  late String name;
  late String description;
  late String image;
  late String object;

  ThreeDObject({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.object,
  });

  ThreeDObject clone() {
    return ThreeDObject(
      id: id,
      name: name,
      description: description,
      image: image,
      object: object,
    );
  }

  ThreeDObject.defaultConstructor();

  // JSON serialization
  factory ThreeDObject.fromJson(Map<String, dynamic> json) =>
      _$ThreeDObjectFromJson(json);
  Map<String, dynamic> toJson() => _$ThreeDObjectToJson(this);

  static ThreeDObject fromMap(Map<String, dynamic> json) {
    ThreeDObject obj = ThreeDObject(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      object: json['object'] as String,
    );
    return obj;
  }
}


// import 'package:json_annotation/json_annotation.dart';

// part 'threeDObject.g.dart';

// @JsonSerializable()
// class ThreeDObject {
//   late int id;
//   late String name;
//   late String description;
//   late String descriptionAudio;
//   late String image;
//   late String object;   

//   ThreeDObject(
//     {
//       required this.id,
//       required this.name,
//       required this.description,
//       required this.image,
//       required this.object
//     }
//   );

//   ThreeDObject clone() {
//     return ThreeDObject(
//         id: id,
//         name: name,
//         description: description,
//         image: image,
//         object: object,
//       );
//   }

//   ThreeDObject.defaultConstructor();

//   factory ThreeDObject.fromJson(Map<String, dynamic> json) =>
//       _$ThreeDObjectFromJson(json);
//   Map<String, dynamic> toJson() => _$ThreeDObjectToJson(this);

//   static ThreeDObject fromMap(Map<String, dynamic> json) {
//     ThreeDObject obj = ThreeDObject(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       description: json['description'] as String,
//       image: json['image'] as String,
//       object: json['data'] as String,
//     );
//     return obj;
//   }
// }
