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
      colorScheme: colorScheme.copyWith(
        secondary: designSystemColor.accentColor,
      ),
      primaryColor: designSystemColor.primaryColor,
      indicatorColor: designSystemColor.indicatorColor,
      splashColor: designSystemColor.splashColor,
      splashFactory: InkRipple.splashFactory,
      canvasColor: designSystemColor.canvasColor,
      backgroundColor: designSystemColor.backgroundColor,
      scaffoldBackgroundColor: designSystemColor.scaffoldBackgroundColor,
      errorColor: designSystemColor.errorColor,
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
    );
  }

  static TextTheme _buildDesignTextTheme(
      TextTheme base, DesignSystemColors designSystemColor) {
    const fontName = 'WorkSans';
    return base.copyWith(
      headline1: base.headline1!.copyWith(fontFamily: fontName),
      headline2: base.headline2!.copyWith(fontFamily: fontName),
      headline3: base.headline3!.copyWith(fontFamily: fontName),
      headline4: base.headline4!.copyWith(fontFamily: fontName),
      headline5: base.headline5!.copyWith(fontFamily: fontName),
      headline6: base.headline6!.copyWith(fontFamily: fontName),
      button: base.button!.copyWith(fontFamily: fontName),
      caption: base.caption!.copyWith(fontFamily: fontName),
      bodyText1: base.bodyText1!.copyWith(
          fontFamily: fontName, color: designSystemColor.bodyTextColor1),
      bodyText2: base.bodyText2!.copyWith(
          fontFamily: fontName, color: designSystemColor.bodyTextColor2),
      subtitle1: base.subtitle1!.copyWith(fontFamily: fontName),
      subtitle2: base.subtitle2!.copyWith(fontFamily: fontName),
      overline: base.overline!.copyWith(fontFamily: fontName),
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
