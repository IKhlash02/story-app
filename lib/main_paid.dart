import 'package:flutter/material.dart';

import 'flavor_config.dart';
import 'my_app.dart';

void main() {
  FlavorConfig(
    flavor: FlavorType.paid,
    color: Colors.blue,
    values: const FlavorValues(
      isFree: false,
    ),
  );

  runApp(const MyApp());
}
