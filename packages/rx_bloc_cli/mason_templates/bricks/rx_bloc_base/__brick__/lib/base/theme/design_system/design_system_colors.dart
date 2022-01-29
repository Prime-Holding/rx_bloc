{{> licence.dart }}

import 'package:flutter/material.dart';

class DesignSystemColors {
  DesignSystemColors({required this.brightness});

  late Brightness brightness;

  /// region Essential (Material and component) colors

  bool get lightMode => brightness == Brightness.light;

  final Color _blackVariant = _HexColor('#36393d');

  Color get primaryColor => lightMode ? Colors.blue : _blackVariant;

  Color get primaryVariant => lightMode ? Colors.blue.shade700 : Colors.black;

  Color get secondaryColor => Colors.white;

  Color get indicatorColor => Colors.white;

  Color get splashColor => Colors.white24;

  Color get canvasColor => Colors.white;

  Color get backgroundColor => lightMode ? Colors.white : Colors.black;

  Color get reverseBackgroundColor => lightMode ? Colors.black : Colors.white;

  Color get scaffoldBackgroundColor => lightMode ? Colors.white : Colors.black;

  Color get errorColor => lightMode ? Colors.red : Colors.redAccent;

  Color? get accentColor =>
      lightMode ? Colors.blue[500] : Colors.tealAccent[200];

  Color get primaryIconColor => lightMode ? Colors.blue : Colors.white;

  Color? get secondaryIconColor => lightMode ? Colors.white : accentColor;

  Color? get tertiaryIconColor => lightMode ? Colors.blue : accentColor;

  Color get bodyTextColor1 =>
      lightMode ? Colors.grey.withOpacity(0.8) : Colors.black;

  Color get bodyTextColor2 => lightMode ? Colors.black : Colors.white;

  Color get subtitleColor1 =>
      lightMode ? Colors.grey.withOpacity(0.8) : Colors.white;

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

  Color? get appTitleColor => lightMode ? Colors.white : accentColor;

  Color? get chipTitleColor => lightMode ? Colors.black : accentColor;

  Color get chipBackgroundColor =>
      lightMode ? Colors.grey.withOpacity(0.8) : Colors.black;

  Color get alertPrimaryTitleColor => Colors.white;

  Color get alertSecondaryTitleColor => Colors.black;

  Color get inputDecorationLabelColor =>
      lightMode ? const Color(0xff333333) : const Color(0xffcccccc);

  Color get inputDecorationErrorLabelColor => Colors.red;

  Color get iconColor => Colors.white;

  Color get outlinedButtonTextColor => Colors.white;

  /// endregion

  /// region App-specific colors

  Color get inactiveButtonColor => Colors.blueGrey;

  Color get activeButtonColor => Colors.blue;

  Color get inactiveButtonTextColor => Colors.grey;

  Color get activeButtonTextColor => Colors.white;

  Color get progressIndicatorBackgroundColor => Colors.white;

  /// endregion
}

class _HexColor extends Color {
  _HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    var hex = hexColor.toUpperCase().replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return int.parse(hex, radix: 16);
  }
}
