// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Object3d.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Object3d _$Object3dFromJson(Map<String, dynamic> json) => Object3d(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      data: json['data'] as String,
      isAnimated: json['isAnimated'] as bool,
    );

Map<String, dynamic> _$Object3dToJson(Object3d instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'data': instance.data,
      'image': instance.image,
      'isAnimated' : instance.isAnimated
    };
