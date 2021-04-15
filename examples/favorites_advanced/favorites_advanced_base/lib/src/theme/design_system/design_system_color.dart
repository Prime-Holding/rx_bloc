import 'package:flutter/material.dart';

class DesignSystemColor {
  late Brightness brightness;

  DesignSystemColor({required this.brightness});

  Color _blackVariant = _HexColor('#36393d');

  bool get lightMode => brightness == Brightness.light;

  Color get primaryColor => lightMode ? Colors.blue : Colors.black;

  Color get primaryVariant => lightMode ? Colors.blueAccent : _blackVariant;

  Color get secondaryColor => Colors.white;

  Color get indicatorColor => Colors.white;

  Color get splashColor => Colors.white24;

  Color get canvasColor => Colors.white;

  Color get backgroundColor => lightMode ? Colors.white : Colors.black;

  Color get scaffoldBackgroundColor => lightMode ? Colors.white : Colors.black;

  Color get buttonColor => Colors.white;

  Color get errorColor => Colors.white;

  Color? get accentColor =>
      lightMode ? Colors.blue[500] : Colors.tealAccent[200];

  Color get primaryIconColor => lightMode ? Colors.blue : Colors.white;

  Color? get secondaryIconColor => lightMode ? Colors.white : accentColor;

  Color? get tertiaryIconColor => lightMode ? Colors.blue : accentColor;

  Color get bodyTextColor1 =>
      lightMode ? Colors.grey.withOpacity(0.8) : Colors.black;

  Color get bodyTextColor2 => lightMode ? Colors.black : Colors.white;

  Color get subtitleColor2 =>
      lightMode ? Colors.grey.withOpacity(0.8) : Colors.white;

  Color get headline1 =>
      lightMode ? Colors.grey.withOpacity(0.8) : Colors.white;

  Color get headline2 =>
      lightMode ? Colors.grey.withOpacity(0.8) : Colors.white;

  Color get headline3 => Colors.black;

  Color get headline4 =>
      lightMode ? Colors.grey.withOpacity(0.8) : Colors.white;

  Color get headline5 =>
      lightMode ? Colors.grey.withOpacity(0.8) : Colors.white;

  Color get headline6 =>
      lightMode ? Colors.grey.withOpacity(0.8) : Colors.white;

  Color get containerColor => lightMode ? Colors.white : _blackVariant;

  Color? get appTitleColor => lightMode ? Colors.white : accentColor;

  Color? get chipTitleColor => lightMode ? Colors.black : accentColor;

  Color get chipBackgroundColor =>
      lightMode ? Colors.grey.withOpacity(0.8) : Colors.black;
}

class _HexColor extends Color {
  _HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
