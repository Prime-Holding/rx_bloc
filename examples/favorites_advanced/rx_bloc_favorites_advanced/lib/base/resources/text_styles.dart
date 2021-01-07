import 'package:flutter/material.dart';
import 'package:rx_bloc_favorites_advanced/base/resources/color_styles.dart';

class TextStyles {
  TextStyles._();

  static const List<Shadow> _defaultShadow = [
    Shadow(
      blurRadius: 5,
      color: ColorStyles.shadow,
      offset: Offset(1.5, 1.5),
    ),
  ];

  static const TextStyle defaultTextStyle = TextStyle(
    color: ColorStyles.textColor,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle titleTextStyle = TextStyle(
    color: ColorStyles.white,
    fontSize: 48,
    fontWeight: FontWeight.w500,
    shadows: _defaultShadow,
  );

  static const TextStyle title2TextStyle = TextStyle(
    color: ColorStyles.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle subtitleTextStyle = TextStyle(
    color: ColorStyles.white,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    shadows: _defaultShadow,
  );
}
