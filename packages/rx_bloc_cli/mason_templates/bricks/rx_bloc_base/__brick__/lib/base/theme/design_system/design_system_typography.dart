{{> licence.dart }}

import 'package:flutter/material.dart';

// Typography aligned with Wiser Technology–inspired design system (wisertech.com).
// Use textTheme.* tokens in features (e.g. headlineLarge, labelLarge, bodyMedium).

class DesignSystemTypography {
  DesignSystemTypography();

  static const String family = 'WorkSans';

  final TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 48,
      fontFamily: family,
      fontWeight: FontWeight.w400,
      height: 1.17,
      letterSpacing: -1,
    ),
    displayMedium: TextStyle(
      fontSize: 32,
      fontFamily: family,
      fontWeight: FontWeight.w400,
      height: 1.19,
      letterSpacing: -1,
    ),
    displaySmall: TextStyle(
      fontSize: 32,
      fontFamily: family,
      fontWeight: FontWeight.w400,
      height: 1.19,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontFamily: family,
      fontWeight: FontWeight.w600,
      height: 1.19,
      letterSpacing: -1,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontFamily: family,
      fontWeight: FontWeight.w600,
      height: 1.08,
      letterSpacing: -1,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontFamily: family,
      fontWeight: FontWeight.w600,
      height: 1.20,
      letterSpacing: -1,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontFamily: family,
      fontWeight: FontWeight.w400,
      height: 1.27,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontFamily: family,
      fontWeight: FontWeight.w600,
      height: 1.56,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontFamily: family,
      fontWeight: FontWeight.w400,
      height: 1.43,
      letterSpacing: 0.10,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontFamily: family,
      fontWeight: FontWeight.w300,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontFamily: family,
      fontWeight: FontWeight.w300,
      height: 1.43,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontFamily: family,
      fontWeight: FontWeight.w300,
      height: 1.33,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontFamily: family,
      fontWeight: FontWeight.w400,
      height: 1.25,
      letterSpacing: 2,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontFamily: family,
      fontWeight: FontWeight.w400,
      height: 1.14,
      letterSpacing: 2,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontFamily: family,
      fontWeight: FontWeight.w400,
      height: 1.17,
      letterSpacing: 2,
    ),
  );
}
