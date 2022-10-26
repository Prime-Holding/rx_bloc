{{> licence.dart }}

import 'package:flutter/material.dart';

import './design_system.dart';
import './design_system/design_system_colors.dart';

class {{project_name.pascalCase()}}Theme {
  static ThemeData buildTheme(DesignSystem designSystem) {
    final ThemeData baseTheme;
    final ColorScheme baseColorScheme;
    final designSystemColor = designSystem.colors;

    if (designSystemColor.brightness == Brightness.light) {
      baseTheme = ThemeData.light();
    } else {
      baseTheme = ThemeData.dark();
    }

    baseColorScheme = baseTheme.colorScheme;

    final colorScheme = baseColorScheme.copyWith(
      primary: designSystemColor.primaryColor,
      background: designSystemColor.backgroundColor,
      error: designSystemColor.errorColor,
    );

    const fontName = 'WorkSans';

    return baseTheme.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: designSystemColor.scaffoldBackgroundColor,
      textTheme: baseTheme.textTheme.apply(fontFamily: fontName),
      primaryTextTheme: baseTheme.primaryTextTheme.apply(fontFamily: fontName),
      iconTheme: _buildIconTheme(baseTheme.iconTheme, designSystemColor),
      extensions: <ThemeExtension<dynamic>>[designSystem],
      // Override any material widget themes here if needed.
    );
  }

  static IconThemeData _buildIconTheme(
          IconThemeData base, DesignSystemColors designSystemColors) =>
      base.copyWith(
        color: designSystemColors.primaryColor,
      );
}
