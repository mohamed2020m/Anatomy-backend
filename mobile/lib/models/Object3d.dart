import 'package:json_annotation/json_annotation.dart';

part 'object3d.g.dart';

@JsonSerializable()
class Object3d {
  late int id;
  late String name;
  late String description;
  late String data;
  late String image;
  late bool isAnimated;

  Object3d(
      {required this.id,
      required this.name,
      required this.description,
      required this.image,
      required this.data,
      required this.isAnimated});

  Object3d clone() {
    return Object3d(
        id: id,
        name: name,
        description: description,
        image: image,
        data: data,
        isAnimated: isAnimated);
  }

  Object3d.defaultConstructor();
  factory Object3d.fromJson(Map<String, dynamic> json) =>
      _$Object3dFromJson(json);
  Map<String, dynamic> toJson() => _$Object3dToJson(this);

  static Object3d fromMap(Map<String, dynamic> json) {
    bool isAnimated = (json['isAnimated'] as int) == 1;
    Object3d obj = Object3d(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String,
        image: json['image'] as String,
        data: json['data'] as String,
        isAnimated: isAnimated);
    return obj;
  }
}
