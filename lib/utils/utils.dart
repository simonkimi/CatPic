import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:catpic/data/database/entity/website.dart';
import 'package:vibration/vibration.dart';

final startDate = DateTime.now();

void printTimeLine([String? tag]) {
  final thisTime = DateTime.now();
  print('${tag ?? 'TimeLine'}: ${thisTime.difference(startDate).toString()}');
}

extension IterableUtils<T> on Iterable<T> {
  T? get(bool test(T e)) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}

extension ListHelper<T> on List<T> {
  T random() {
    return this[Random().nextInt(length)];
  }

  List<T> addAsSet(Iterable<T> other) {
    addAll(other.where((e) => !contains(e)));
    return this;
  }
}

extension ColorHelper on Color {
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

extension MapHelper<K, V> on Map<K, V> {
  Map<K, V> get trim {
    return Map.fromEntries(
        entries.where((element) => element.value.toString().isNotEmpty));
  }
}

extension AnimationControllerHelper on AnimationController {
  void byValue(bool display) {
    if (display && atEnd) reverse();
    if (!display && atStart) forward();
  }

  void play(bool isForward) {
    if (isForward) {
      forward();
    } else {
      reverse();
    }
  }

  bool get atStart => value == 0.0;

  bool get atEnd => value == 1.0;
}

void tryCatch(Function? f) {
  try {
    f?.call();
  } catch (e, stack) {
    log('$e');
    log('$stack');
  }
}

T? asT<T extends Object?>(dynamic value, [T? defaultValue]) {
  if (value is T) {
    return value;
  }
  try {
    if (value != null) {
      final String valueS = value.toString();
      if ('' is T) {
        return valueS as T;
      } else if (0 is T) {
        return int.parse(valueS) as T;
      } else if (0.0 is T) {
        return double.parse(valueS) as T;
      } else if (false is T) {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else {
        return FFConvert.convert<T>(value);
      }
    }
  } catch (e, stackTrace) {
    log('asT<$T>', error: e, stackTrace: stackTrace);
    return defaultValue;
  }

  return defaultValue;
}

class FFConvert {
  FFConvert._();

  static T? Function<T extends Object?>(dynamic value) convert =
      <T>(dynamic value) {
    if (value == null) {
      return null;
    }
    return json.decode(value.toString()) as T?;
  };
}

Future<void> vibrate({
  int duration = 500,
  List<int> pattern = const [],
  int repeat = -1,
  List<int> intensities = const [],
  int amplitude = -1,
}) async {
  if ((Platform.isIOS || Platform.isAndroid) &&
      (await Vibration.hasVibrator() ?? false)) {
    Vibration.vibrate(
      duration: duration,
      pattern: pattern,
      repeat: repeat,
      intensities: intensities,
      amplitude: amplitude,
    );
  }
}

class Log {
  static void i([
    dynamic p1,
    dynamic p2,
    dynamic p3,
    dynamic p4,
    dynamic p5,
    dynamic p6,
    dynamic p7,
    dynamic p8,
    dynamic p9,
  ]) {
    print([p1, p2, p3, p4, p5, p6, p7, p8, p9]
        .where((e) => e != null)
        .map((e) => e.toString())
        .join(' '));
  }
}
