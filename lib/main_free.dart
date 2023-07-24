import 'package:flutter/material.dart';

import 'flavor_config.dart';
import 'my_app.dart';

void main() {
  FlavorConfig(
    flavor: FlavorType.free,
    color: Colors.deepPurple,
    values: const FlavorValues(
      isFree: true,
      titleApp: "Paid Story Apps",
    ),
  );

  runApp(const MyApp());
}
