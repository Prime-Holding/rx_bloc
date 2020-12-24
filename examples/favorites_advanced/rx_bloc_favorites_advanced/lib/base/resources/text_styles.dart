import 'package:flutter/material.dart';
import 'package:rx_bloc_favorites_advanced/base/resources/color_styles.dart';

class TextStyles {
  TextStyles._();

  static const double fontSize14 = 14;
  static const double fontSize18 = 18;
  static const double fontSize22 = 22;

  static const TextStyle defaultTextStyle = TextStyle(
    color: ColorStyles.textColor,
    fontSize: fontSize18,
    fontWeight: FontWeight.w500,
  );

  static TextStyle titleTextStyle = TextStyle(
    color: ColorStyles.textColor.withOpacity(0.75),
    fontSize: fontSize22,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle title2TextStyle = TextStyle(
    color: ColorStyles.titleColor,
    fontSize: fontSize18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle subtitleTextStyle = TextStyle(
    color: ColorStyles.titleColor,
    fontSize: fontSize14,
    fontWeight: FontWeight.w500,
  );
}
