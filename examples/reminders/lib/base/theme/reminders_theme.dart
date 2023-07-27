// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

import './design_system.dart';
import './design_system/design_system_colors.dart';

class RemindersTheme {
  static ThemeData buildTheme(DesignSystem designSystem) {
    final designSystemColor = designSystem.colors;
    final lightModeOn = designSystemColor.brightness == Brightness.light;
    final colorSchemeTheme =
        lightModeOn ? const ColorScheme.light() : const ColorScheme.dark();
    final colorScheme = colorSchemeTheme.copyWith(
      primary: designSystemColor.primaryColor,
      secondary: designSystemColor.secondaryColor,
    );
    final base = lightModeOn ? ThemeData.light() : ThemeData.dark();
    return base.copyWith(
      primaryColor: designSystemColor.primaryColor,
      indicatorColor: designSystemColor.indicatorColor,
      splashColor: designSystemColor.splashColor,
      splashFactory: InkRipple.splashFactory,
      canvasColor: designSystemColor.canvasColor,
      scaffoldBackgroundColor: designSystemColor.scaffoldBackgroundColor,
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      textButtonTheme:
          _buildTextButtonTheme(base.textButtonTheme, designSystem),
      outlinedButtonTheme:
          _buildOutlinedButtonTheme(base.outlinedButtonTheme, designSystem),
      textTheme: _buildDesignTextTheme(base.textTheme, designSystemColor),
      primaryTextTheme:
          _buildDesignTextTheme(base.primaryTextTheme, designSystemColor),
      appBarTheme: AppBarTheme(
        color: designSystemColor.primaryVariant,
      ),
      iconTheme: _buildIconTheme(base.iconTheme, designSystemColor),
      colorScheme: colorScheme
          .copyWith(
            secondary: designSystemColor.accentColor,
          )
          .copyWith(background: designSystemColor.backgroundColor)
          .copyWith(error: designSystemColor.errorColor),
    );
  }

  static TextTheme _buildDesignTextTheme(
      TextTheme base, DesignSystemColors designSystemColor) {
    const fontName = 'WorkSans';
    return base.copyWith(
      displayLarge: base.displayLarge!.copyWith(fontFamily: fontName),
      displayMedium: base.displayMedium!.copyWith(fontFamily: fontName),
      displaySmall: base.displaySmall!.copyWith(fontFamily: fontName),
      headlineMedium: base.headlineMedium!.copyWith(fontFamily: fontName),
      headlineSmall: base.headlineSmall!.copyWith(fontFamily: fontName),
      titleLarge: base.titleLarge!.copyWith(fontFamily: fontName),
      labelLarge: base.labelLarge!.copyWith(fontFamily: fontName),
      bodySmall: base.bodySmall!.copyWith(fontFamily: fontName),
      bodyLarge: base.bodyLarge!.copyWith(
          fontFamily: fontName, color: designSystemColor.bodyTextColor1),
      bodyMedium: base.bodyMedium!.copyWith(
          fontFamily: fontName, color: designSystemColor.bodyTextColor2),
      titleMedium: base.titleMedium!.copyWith(fontFamily: fontName),
      titleSmall: base.titleSmall!.copyWith(fontFamily: fontName),
      labelSmall: base.labelSmall!.copyWith(fontFamily: fontName),
    );
  }

  static IconThemeData _buildIconTheme(
          IconThemeData base, DesignSystemColors designSystemColors) =>
      base.copyWith(
        color: designSystemColors.iconColor,
      );

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(
          OutlinedButtonThemeData data, DesignSystem designSystem) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: designSystem.colors.primaryColor,
          textStyle: designSystem.typography.outlinedButtonText,
          foregroundColor: designSystem.colors.outlinedButtonTextColor,
          side: BorderSide(
            width: 2,
            color: designSystem.colors.primaryVariant,
          ),
        ),
      );

  static TextButtonThemeData _buildTextButtonTheme(
          TextButtonThemeData data, DesignSystem designSystem) =>
      TextButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: designSystem.colors.secondaryColor,
          textStyle: designSystem.typography.textButtonText,
          foregroundColor: designSystem.colors.textButtonTextColor,
        ),
      );
}
