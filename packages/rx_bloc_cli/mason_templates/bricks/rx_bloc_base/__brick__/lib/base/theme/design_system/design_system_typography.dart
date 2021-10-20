{{> licence.dart }}

import 'package:flutter/material.dart';

import 'design_system_colors.dart';

class DesignSystemTypography {
  DesignSystemTypography._create(DesignSystemColors designSystemColor) {
    _designSystemColor = designSystemColor;
  }

  factory DesignSystemTypography.withColor(
          DesignSystemColors designSystemColor) =>
      DesignSystemTypography._create(designSystemColor);

  late DesignSystemColors _designSystemColor;

  /// Material design typography:
  /// https://material.io/design/typography/the-type-system.html#type-scale

  final FontWeight _medium = FontWeight.w500;
  final FontWeight _regular = FontWeight.w400;
  final FontWeight _light = FontWeight.w300;

  TextStyle get headline1 => TextStyle(
        fontWeight: _light,
        fontSize: 96,
        color: _designSystemColor.headline1,
        letterSpacing: -1.5,
      );

  TextStyle get headline2 => TextStyle(
        fontWeight: _light,
        fontSize: 60,
        color: _designSystemColor.headline2,
        letterSpacing: -0.5,
      );

  TextStyle get headline3 => TextStyle(
        fontWeight: _regular,
        fontSize: 48,
        color: _designSystemColor.headline3,
        letterSpacing: 0,
      );

  TextStyle get headline4 => TextStyle(
        fontWeight: _regular,
        fontSize: 34,
        color: _designSystemColor.headline4,
        letterSpacing: 0.25,
      );

  TextStyle get headline5 => TextStyle(
        fontWeight: _regular,
        fontSize: 24,
        color: _designSystemColor.headline5,
        letterSpacing: 0,
      );

  TextStyle get headline6 => TextStyle(
        fontWeight: _medium,
        fontSize: 20,
        color: _designSystemColor.headline6,
        letterSpacing: 0.15,
      );

  TextStyle get subtitle1 => TextStyle(
        fontWeight: _regular,
        fontSize: 16,
        color: _designSystemColor.subtitleColor1,
        letterSpacing: 0.15,
      );

  TextStyle get subtitle2 => TextStyle(
        fontWeight: _medium,
        fontSize: 14,
        color: _designSystemColor.subtitleColor2,
        letterSpacing: 0.1,
      );

  TextStyle get bodyText1 => TextStyle(
        fontWeight: _regular,
        fontSize: 16,
        color: _designSystemColor.bodyTextColor1,
        letterSpacing: 0.5,
      );

  TextStyle get bodyText2 => TextStyle(
        fontWeight: _regular,
        fontSize: 14,
        color: _designSystemColor.bodyTextColor2,
        letterSpacing: 0.25,
      );

  TextStyle get buttonMain => TextStyle(
        fontWeight: _medium,
        color: _designSystemColor.secondaryColor,
        fontSize: 14,
        letterSpacing: 1.25,
      );

  TextStyle get appBarTitle => TextStyle(
        color: _designSystemColor.appTitleColor,
      );

  TextStyle get chipTitle => TextStyle(
        color: _designSystemColor.chipTitleColor,
      );

  TextStyle get alertPrimaryTitle => TextStyle(
        fontSize: 18,
        color: _designSystemColor.alertPrimaryTitleColor,
      );

  TextStyle get alertSecondaryTitle => TextStyle(
        fontSize: 18,
        color: _designSystemColor.alertSecondaryTitleColor,
      );

  /// UI component typography

  TextStyle get outlinedButtonText => TextStyle(
        fontWeight: _medium,
        color: _designSystemColor.outlinedButtonTextColor,
        fontSize: 14,
      );

  /// App specific typography

  TextStyle get counterTitle => TextStyle(
        fontSize: 12,
        color: _designSystemColor.secondaryIconColor,
      );

  TextStyle get fadedButtonText => TextStyle(
        fontWeight: _medium,
        color: _designSystemColor.reverseBackgroundColor.withOpacity(0.6),
        fontSize: 14,
      );
}
