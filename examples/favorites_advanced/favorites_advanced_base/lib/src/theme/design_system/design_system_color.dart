import 'package:flutter/material.dart';

abstract class DesignSystemColor {
  factory DesignSystemColor(Brightness brightness) {
    if (brightness == Brightness.light) {
      return designSystemColorsLight;
    }

    return designSystemColorsDark;
  }

  DesignSystemColor._create();

  static final DesignSystemColorLight designSystemColorsLight =
      DesignSystemColorLight();
  static final DesignSystemColorDark designSystemColorsDark =
      DesignSystemColorDark();

  Brightness get brightness;
  Color get primaryColor;
  Color get secondaryColor;
  Color get indicatorColor;
  Color get splashColor;
  Color get canvasColor;
  Color get backgroundColor;
  Color get scaffoldBackgroundColor;
  Color get errorColor;
  Color get curvedNavigationBarColor;
  Color get curvedNavigationIconColor;
}

class DesignSystemColorLight extends DesignSystemColor {
  DesignSystemColorLight() : super._create();

  @override
  Brightness get brightness => Brightness.light;

  @override
  Color get primaryColor => _HexColor('#54D3C2');

  @override
  Color get secondaryColor => _HexColor('#54D3C2');

  @override
  Color get indicatorColor => Colors.white;

  @override
  Color get splashColor => Colors.white24;

  @override
  Color get canvasColor => Colors.white;

  @override
  Color get backgroundColor => Colors.white;

  @override
  Color get scaffoldBackgroundColor => Colors.white;

  @override
  Color get errorColor => Colors.white;

  @override
  Color get curvedNavigationBarColor => Colors.blueAccent;

  @override
  Color get curvedNavigationIconColor => Colors.white;
}

class DesignSystemColorDark extends DesignSystemColor {
  DesignSystemColorDark() : super._create();

  @override
  Brightness get brightness => Brightness.dark;

  @override
  Color get primaryColor => _HexColor('#54D3C2');

  @override
  Color get secondaryColor => _HexColor('#54D3C2');

  @override
  Color get indicatorColor => Colors.white;

  @override
  Color get splashColor => Colors.white24;

  @override
  Color get canvasColor => Colors.white;

  @override
  Color get backgroundColor => Colors.black;

  @override
  Color get scaffoldBackgroundColor => Colors.black;

  @override
  Color get errorColor => Colors.white;

  @override
  Color get curvedNavigationBarColor => Colors.white;

  @override
  Color get curvedNavigationIconColor => Colors.black;
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
