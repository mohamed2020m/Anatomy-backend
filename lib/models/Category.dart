import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  late int id;
  late String name;
  late String description;
  late String image;
  // late int parentCategoryId;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    // required this.parentCategoryId,
  });

  Category.defaultConstructor();

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
