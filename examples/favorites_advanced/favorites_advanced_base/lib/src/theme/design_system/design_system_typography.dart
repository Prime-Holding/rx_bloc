import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';

class DesignSystemTypography {
  factory DesignSystemTypography.withColor(
      DesignSystemColor designSystemColor) {
    return DesignSystemTypography._create(designSystemColor);
  }

  DesignSystemTypography._create(DesignSystemColor designSystemColor) {
    _designSystemColor = designSystemColor;
  }

  late DesignSystemColor _designSystemColor;

  TextStyle get headline1 => TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 16,
      color: Colors.grey.withOpacity(0.8));

  TextStyle get headline2 => TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 16,
      color: Colors.grey.withOpacity(0.8));

  TextStyle get headline3 => TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 16,
      color: Colors.grey.withOpacity(0.8));

  TextStyle get headline4 => TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 16,
      color: Colors.grey.withOpacity(0.8));

  TextStyle get headline5 => TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 16,
      color: Colors.grey.withOpacity(0.8));

  TextStyle get headline6 => TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 16,
      color: Colors.grey.withOpacity(0.8));

  TextStyle get subtitle1 => TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22,
      );

  TextStyle get subtitle2 => TextStyle(
        fontSize: 14,
        color: _designSystemColor.subtitleColor2,
      );

  TextStyle get bodyText1 => TextStyle(
        fontSize: 14,
        color: _designSystemColor.bodyTextColor1,
      );

  TextStyle get bodyText2 => TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 16,
      color: Colors.grey.withOpacity(0.8));
}
