import 'package:flutter/material.dart';

enum FlavorType {
  free,
  paid,
}

class FlavorValues {
  final bool isFree;
  final String titleApp;

  const FlavorValues({
    this.isFree = true,
    this.titleApp = "Free Story Apps",
  });
}

class FlavorConfig {
  final FlavorType flavor;
  final MaterialColor color;
  final FlavorValues values;

  static FlavorConfig? _instance;

  FlavorConfig({
    this.flavor = FlavorType.free,
    this.color = Colors.deepPurple,
    this.values = const FlavorValues(),
  }) {
    _instance = this;
  }

  static FlavorConfig get instance => _instance ?? FlavorConfig();
}
