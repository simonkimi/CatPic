import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:catpic/data/database/entity/website.dart';

extension IterableUtils<T> on Iterable<T> {
  T? firstOrNull(bool test(T element)) {
    for (final T element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension ColorExtension on Color {
  MaterialColor get swatch => Colors.primaries.firstWhere(
        (Color c) => c.value == value,
    orElse: () => _swatch,
  );

  MaterialColor get _swatch => MaterialColor(value, getMaterialColorValues);

  Map<int, Color> get getMaterialColorValues => <int, Color>{
    50: _swatchShade(50),
    100: _swatchShade(100),
    200: _swatchShade(200),
    300: _swatchShade(300),
    400: _swatchShade(400),
    500: _swatchShade(500),
    600: _swatchShade(600),
    700: _swatchShade(700),
    800: _swatchShade(800),
    900: _swatchShade(900),
  };

  Color _swatchShade(int swatchValue) => HSLColor.fromColor(this)
      .withLightness(1 - (swatchValue / 1000))
      .toColor();
}



String? getSchemeString(int? scheme) {
  if (scheme == null) return null;
  return scheme == WebsiteScheme.HTTP.index ? 'http' : 'https';
}

extension StringHelper on String {
  String getHost() {
    final items = split('/')
        .where((e) => e != 'http:' && e != 'https:')
        .where((e) => e.isNotEmpty)
        .toList();
    return items.isNotEmpty ? items[0] : '';
  }

  int toInt() => int.tryParse(this) ?? 0;
}
