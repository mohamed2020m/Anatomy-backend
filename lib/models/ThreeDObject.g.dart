// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ThreeDObject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreeDObject _$ThreeDObjectFromJson(Map<String, dynamic> json) => ThreeDObject(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      object: json['object'] as String,
    );

Map<String, dynamic> _$ThreeDObjectToJson(ThreeDObject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'object': instance.object,
    };
