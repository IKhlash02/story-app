// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_StoryElement _$$_StoryElementFromJson(Map<String, dynamic> json) =>
    _$_StoryElement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      photoUrl: json['photoUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$_StoryElementToJson(_$_StoryElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'photoUrl': instance.photoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'lat': instance.lat,
      'lon': instance.lon,
    };
