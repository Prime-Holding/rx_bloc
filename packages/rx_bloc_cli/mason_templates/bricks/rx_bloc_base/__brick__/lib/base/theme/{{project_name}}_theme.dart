{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:widget_toolkit/widget_toolkit.dart';{{#has_otp}}
import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';{{/has_otp}}{{#enable_pin_code}}
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';{{/enable_pin_code}}{{#enable_feature_qr_scanner}}
import 'package:widget_toolkit_qr/widget_toolkit_qr.dart';{{/enable_feature_qr_scanner}}

import './design_system.dart';

class {{project_name.pascalCase()}}Theme {
  static ThemeData buildTheme(DesignSystem designSystem) {
    final isLightTheme = designSystem.colors.brightness == Brightness.light;

    final onSurface = designSystem.colors.colorScheme.onSurface;
    return (isLightTheme ? ThemeData.light() : ThemeData.dark()).copyWith(
      colorScheme: designSystem.colors.colorScheme,
      scaffoldBackgroundColor: designSystem.colors.colorScheme.surface,
      textTheme: designSystem.typography.textTheme.apply(
        bodyColor: onSurface,
        displayColor: onSurface,
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: (designSystem.typography.textTheme.headlineSmall ?? const TextStyle()).copyWith(
          color: onSurface,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: designSystem.colors.colorScheme.primaryContainer,
        selectedItemColor: designSystem.colors.colorScheme.onPrimaryContainer,
        unselectedItemColor: designSystem.colors.colorScheme.onSurfaceVariant,
      ),
      extensions: <ThemeExtension<dynamic>>[
        designSystem,
        isLightTheme ? WidgetToolkitTheme.light() : WidgetToolkitTheme.dark(),
        isLightTheme ? ItemPickerTheme.light() : ItemPickerTheme.dark(),
        isLightTheme ? SearchPickerTheme.light() : SearchPickerTheme.dark(),
        isLightTheme
            ? TextFieldDialogTheme.light()
            : TextFieldDialogTheme.dark(),
        isLightTheme ? EditAddressTheme.light() : EditAddressTheme.dark(),
        isLightTheme ? LanguagePickerTheme.light() : LanguagePickerTheme.dark(),{{#has_otp}}
        isLightTheme ? SmsCodeTheme.light() : SmsCodeTheme.dark(),{{/has_otp}}{{#enable_pin_code}}
        isLightTheme ? PinCodeTheme.light() : PinCodeTheme.dark(),{{/enable_pin_code}}{{#enable_feature_qr_scanner}}
        isLightTheme ? QrScannerTheme.light() : QrScannerTheme.dark(),{{/enable_feature_qr_scanner}}
      ],
    );
  }
}
