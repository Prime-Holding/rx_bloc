{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:widget_toolkit/widget_toolkit.dart';{{#has_otp}}
import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';{{/has_otp}}{{#enable_pin_code}}
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';{{/enable_pin_code}}{{#enable_feature_qr_scanner}}
import 'package:widget_toolkit_qr/widget_toolkit_qr.dart';{{/enable_feature_qr_scanner}}

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
      surface: designSystemColor.backgroundColor,
      error: designSystemColor.errorColor,
      surfaceTint: designSystemColor.primaryColor,
    );

    const fontName = 'WorkSans';

    return baseTheme.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: designSystemColor.scaffoldBackgroundColor,
      textTheme: baseTheme.textTheme.apply(fontFamily: fontName),
      primaryTextTheme: baseTheme.primaryTextTheme.apply(fontFamily: fontName),
      iconTheme: _buildIconTheme(baseTheme.iconTheme, designSystemColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: designSystemColor.backgroundColor,
      ),
      cardTheme: CardTheme(
        color: designSystemColor.backgroundColor,
        surfaceTintColor: designSystem.colors.gray,
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: designSystemColor.textButtonColor)),
      extensions: <ThemeExtension<dynamic>>[
        designSystem,
        isLightTheme ? WidgetToolkitTheme.light() : WidgetToolkitTheme.dark(),
        isLightTheme ? ItemPickerTheme.light() : ItemPickerTheme.dark(),
        isLightTheme ? SearchPickerTheme.light() : SearchPickerTheme.dark(),
        isLightTheme ? TextFieldDialogTheme.light() : TextFieldDialogTheme.dark(),
        isLightTheme ? EditAddressTheme.light() : EditAddressTheme.dark(),
        isLightTheme ? LanguagePickerTheme.light() : LanguagePickerTheme.dark(),{{#has_otp}}
        isLightTheme ? SmsCodeTheme.light() : SmsCodeTheme.dark(),{{/has_otp}}{{#enable_pin_code}}
        isLightTheme ? PinCodeTheme.light() : PinCodeTheme.dark(),{{/enable_pin_code}}{{#enable_feature_qr_scanner}}
        isLightTheme ? QrScannerTheme.light() : QrScannerTheme.dark(),{{/enable_feature_qr_scanner}}
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
