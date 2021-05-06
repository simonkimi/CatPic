import 'package:catpic/i18n.dart';
import 'package:flutter/material.dart';
import 'package:catpic/utils/utils.dart';

class Themes {
  static const BLUE = 1;
  static const PURPLE = 2;
  static const DARK_BLUE = -1;

  static ThemeData of(int value) {
    switch (value) {
      case Themes.BLUE:
        return blueTheme;
      case Themes.PURPLE:
        return purpleTheme;
      case Themes.DARK_BLUE:
      default:
        return darkBlueTheme;
    }
  }
}

final darkBlueTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: const AppBarTheme(
    color: Color(0xFF212D3B),
    foregroundColor: Color(0xFFFFFFFF),
  ),
  primaryTextTheme: const TextTheme(
    subtitle1: TextStyle(color: Colors.white),
    bodyText1: TextStyle(color: Color(0xFFFFFFFF)),
    bodyText2: TextStyle(
      color: Color(0xFF7B8DA1),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF61AAE1),
  accentColor: const Color(0xFF61AAE1),
  primaryColorDark: const Color(0xFF223040),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      return states.contains(MaterialState.selected)
          ? const Color(0xFF61AAE1)
          : const Color(0xFFB9B9B9);
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      return states.contains(MaterialState.selected)
          ? const Color(0xFF5D7385)
          : const Color(0xFF646464);
    }),
  ),
);

final blueTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: const TextTheme(
    subtitle2: TextStyle(
      color: Color(0xFF9b9cb1),
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  appBarTheme: const AppBarTheme(color: Colors.blue),
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  accentColor: Colors.blue[800],
  primaryColorDark: Colors.blue[800],
  primarySwatch: Colors.blue,
);

const _purplePrimary = Color(0xFF686BDD);

final purpleTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: const TextTheme(
    subtitle2: TextStyle(
      color: Color(0xFF9b9cb1),
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  appBarTheme: const AppBarTheme(color: Color(0xFF686BDD)),
  brightness: Brightness.light,
  primaryColor: _purplePrimary,
  accentColor: const Color(0xFF46489f),
  primaryColorDark: const Color(0xFF46489f),
  primarySwatch: _purplePrimary.swatch,
);

bool isDarkMode([BuildContext? context]) =>
    Theme.of(context ?? I18n.context).brightness == Brightness.dark;

const darkColors = <Color>[
  Color(0xFF253139),
  Color(0xFF3F2623),
  Color(0xFF36464E),
];
