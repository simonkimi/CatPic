import 'package:flutter/material.dart';

final baseTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: const TextTheme(
    subtitle2: TextStyle(
      color: Color(0xFF9b9cb1),
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
);

final blueTheme = baseTheme.copyWith(
  appBarTheme: const AppBarTheme(color: Colors.blue),
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  accentColor: Colors.blue[800],
);

final purpleTheme = baseTheme.copyWith(
  appBarTheme: const AppBarTheme(color: Color(0xFF686BDD)),
  brightness: Brightness.light,
  primaryColor: const Color(0xFF686BDD),
  accentColor: const Color(0xFF46489f),
);
