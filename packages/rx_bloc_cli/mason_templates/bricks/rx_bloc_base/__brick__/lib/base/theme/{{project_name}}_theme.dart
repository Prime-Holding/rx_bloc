{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import './design_system.dart';
import './design_system/design_system_colors.dart';

class {{project_name.pascalCase()}}Theme {
  static ThemeData buildTheme(DesignSystem designSystem) {
    final ThemeData baseTheme;
    final ColorScheme baseColorScheme;
    final designSystemColor = designSystem.colors;

    final isLightTheme = designSystemColor.brightness == Brightness.light;

    if (isLightTheme) {
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
      extensions: <ThemeExtension<dynamic>>[
        designSystem,
        isLightTheme ? WidgetToolkitTheme.light : WidgetToolkitTheme.dark,
        isLightTheme ? ItemPickerTheme.light : ItemPickerTheme.dark,
        isLightTheme ? SearchPickerTheme.light : SearchPickerTheme.dark,
        isLightTheme ? TextFieldDialogTheme.light : TextFieldDialogTheme.dark,
        isLightTheme ? EditAddressTheme.light : EditAddressTheme.dark,
      ],
      // Override any material widget themes here if needed.
    );
  }

  static IconThemeData _buildIconTheme(
          IconThemeData base, DesignSystemColors designSystemColors) =>
      base.copyWith(
        color: designSystemColors.primaryColor,
      );
}
