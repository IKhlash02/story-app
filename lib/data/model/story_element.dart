import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_element.g.dart';
part 'story_element.freezed.dart';

@freezed
class StoryElement with _$StoryElement {
  const factory StoryElement({
    required String id,
    required String name,
    required String description,
    required String photoUrl,
    required DateTime createdAt,
    double? lat,
    double? lon,
  }) = _StoryElement;

  factory StoryElement.fromJson(Map<String, dynamic> json) =>
      _$StoryElementFromJson(json);
}
