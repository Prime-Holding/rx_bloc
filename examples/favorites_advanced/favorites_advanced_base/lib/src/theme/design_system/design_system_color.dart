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
  Color get primaryVariant;
  Color get secondaryColor;
  Color get indicatorColor;
  Color get splashColor;
  Color get canvasColor;
  Color get backgroundColor;
  Color get scaffoldBackgroundColor;
  Color get buttonColor;
  Color get errorColor;
  Color? get accentColor;
  Color get bodyTextColor1;
  Color get subtitleColor2;
}

class DesignSystemColorLight extends DesignSystemColor {
  DesignSystemColorLight() : super._create();

  @override
  Brightness get brightness => Brightness.light;

  @override
  Color get primaryColor => Colors.blue;

  @override
  Color get primaryVariant => Colors.blueAccent;

  @override
  Color get secondaryColor => Colors.white;

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
  Color get buttonColor => Colors.white;

  @override
  Color get errorColor => Colors.white;

  @override
  Color? get accentColor => Colors.blue[500];

  @override
  Color get bodyTextColor1 => Colors.grey.withOpacity(0.8);

  @override
  Color get subtitleColor2 => Colors.grey.withOpacity(0.8);
}

class DesignSystemColorDark extends DesignSystemColor {
  DesignSystemColorDark() : super._create();

  @override
  Brightness get brightness => Brightness.dark;

  @override
  Color get primaryColor => Colors.black;

  @override
  Color get primaryVariant => Colors.black12;

  @override
  Color get secondaryColor => Colors.white;

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
  Color get buttonColor => Colors.white;

  @override
  Color get errorColor => Colors.white;

  @override
  Color? get accentColor => Colors.tealAccent[200];

  @override
  Color get bodyTextColor1 => Colors.white;

  @override
  Color get subtitleColor2 => Colors.white;
}
