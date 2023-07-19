import 'package:json_annotation/json_annotation.dart';

part 'story_element.g.dart';

@JsonSerializable()
class StoryElement {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double? lat;
  final double? lon;

  StoryElement({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory StoryElement.fromJson(Map<String, dynamic> json) =>
      _$StoryElementFromJson(json);

  Map<String, dynamic> toJson() => _$StoryElementToJson(this);
}
