import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  late int id;
  late String lastName;
  late String firstName;
  late String email;


  User({
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.email,

  });

  User.defaultConstructor();
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
