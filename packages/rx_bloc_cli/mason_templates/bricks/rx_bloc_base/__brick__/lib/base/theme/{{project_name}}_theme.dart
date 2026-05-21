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
    final widgetToolkitTheme = _buildWidgetToolkitTheme(designSystem);

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
        widgetToolkitTheme,
        _buildItemPickerTheme(designSystem),
        _buildSearchPickerTheme(designSystem),
        _buildTextFieldDialogTheme(designSystem),
        _buildEditAddressTheme(designSystem),
        _buildLanguagePickerTheme(designSystem),{{#has_otp}}
        _buildSmsCodeTheme(designSystem),{{/has_otp}}{{#enable_pin_code}}
        _buildPinCodeTheme(designSystem),{{/enable_pin_code}}{{#enable_feature_qr_scanner}}
        _buildQrScannerTheme(designSystem),{{/enable_feature_qr_scanner}}
      ],
    );
  }

  static WidgetToolkitTheme _buildWidgetToolkitTheme(
    DesignSystem designSystem,
  ) {
    final isLightTheme = designSystem.colors.brightness == Brightness.light;
    final colorScheme = designSystem.colors.colorScheme;
    final baseTheme = isLightTheme
        ? WidgetToolkitTheme.light()
        : WidgetToolkitTheme.dark();

    final disabledBackground = colorScheme.outlineVariant.withValues(
      alpha: isLightTheme ? 0.7 : 0.35,
    );

    return baseTheme.copyWith(
      primaryColor: designSystem.colors.assertionYellow,
      backgroundColor: colorScheme.surface,
      scaffoldBackgroundColor: colorScheme.surface,
      primaryGradientStart: designSystem.colors.assertionYellow,
      primaryGradientEnd: designSystem.colors.assertionYellow,
      activeGradientColorStart: designSystem.colors.assertionYellow,
      activeGradientColorEnd: designSystem.colors.assertionYellow,
      buttonBlueGradientEnd: designSystem.colors.assertionYellow,
      bottomSheetBackgroundColor: colorScheme.surface,
      bottomSheetBorderColor: colorScheme.outlineVariant,
      bottomSheetLineColor: colorScheme.outline,
      searchTextFieldBackgroundColor: colorScheme.surfaceContainerLowest,
      searchTextFieldBackgroundColorActive: colorScheme.surfaceContainerLow,
      searchTextFieldTextStyle: baseTheme.searchTextFieldTextStyle.copyWith(
        color: colorScheme.primary,
      ),
      pickerListItemUnselectedColor: colorScheme.surfaceContainerLowest,
      pickerListItemSelectedColor: colorScheme.surfaceContainer,
      searchTextFieldBorderType: Border.all(
        color: colorScheme.outlineVariant,
        width: 1,
      ),
      filledButtonBackgroundColorPressed: colorScheme.primaryContainer,
      buttonPressedColor: colorScheme.primaryContainer,
      filledButtonTextColorEnabled: colorScheme.onPrimary,
      filledButtonBackgroundColorDisabled: disabledBackground,
      filledButtonTextColorDisabled: colorScheme.onSurfaceVariant,
      gradientFillButtonDefaultPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
    );
  }

  static ItemPickerTheme _buildItemPickerTheme(DesignSystem designSystem) {
    final isLightTheme = designSystem.colors.brightness == Brightness.light;
    final colorScheme = designSystem.colors.colorScheme;
    final baseTheme = isLightTheme
        ? ItemPickerTheme.light()
        : ItemPickerTheme.dark();

    return baseTheme.copyWith(
      titleStyle: baseTheme.titleStyle.copyWith(color: colorScheme.onSurface),
      contentListPadding: EdgeInsets.symmetric(
        horizontal: designSystem.spacing.m,
      ),
    );
  }

  static SearchPickerTheme _buildSearchPickerTheme(DesignSystem designSystem) {
    final isLightTheme = designSystem.colors.brightness == Brightness.light;
    final colorScheme = designSystem.colors.colorScheme;
    final baseTheme = isLightTheme
        ? SearchPickerTheme.light()
        : SearchPickerTheme.dark();

    return baseTheme.copyWith(
      titleStyle: baseTheme.titleStyle.copyWith(color: colorScheme.onSurface),
      searchFieldOuterEdgeInsets: EdgeInsets.symmetric(
        horizontal: designSystem.spacing.m,
      ),
      errorEdgeInsets: EdgeInsets.symmetric(horizontal: designSystem.spacing.m),
    );
  }

  static TextFieldDialogTheme _buildTextFieldDialogTheme(
    DesignSystem designSystem,
  ) {
    final isLightTheme = designSystem.colors.brightness == Brightness.light;
    final colorScheme = designSystem.colors.colorScheme;
    final baseTheme = isLightTheme
        ? TextFieldDialogTheme.light()
        : TextFieldDialogTheme.dark();

    return baseTheme.copyWith(
      textFieldDialogIconColor: colorScheme.primary,
      labelBoxFilledPrimary: colorScheme.primary,
      labelBoxFilledSecondary: colorScheme.onSurface,
      labelBoxFilledBackground: colorScheme.surfaceContainerLow,
      labelBoxOptionalBackground: colorScheme.surfaceContainerLowest,
      labelBoxOptionalBorder: colorScheme.outlineVariant,
      inputFieldBorderTypeColor: colorScheme.primary,
      inputFieldBorderLoadingColor: colorScheme.primary,
      inputFieldBackgroundDefaultColor: colorScheme.surfaceContainerLow,
      inputFieldBackgroundDefaultFieldColor: colorScheme.surfaceContainerLow,
      inputFieldBackgroundDefaultDisabledColor: colorScheme.surfaceContainerLow,
      inputFieldTextDefaultFieldColor: colorScheme.onSurface,
      inputFieldTextTypeColor: colorScheme.onSurface,
      inputFieldTextLoadingColor: colorScheme.onSurface,
      inputFieldHintColor: colorScheme.onSurfaceVariant,
      editFieldValueEditedColor: colorScheme.onSurface,
      disabledFilledButtonBackgroundColor: colorScheme.outlineVariant,
    );
  }

  static EditAddressTheme _buildEditAddressTheme(DesignSystem designSystem) {
    final isLightTheme = designSystem.colors.brightness == Brightness.light;
    final colorScheme = designSystem.colors.colorScheme;
    final baseTheme = isLightTheme
        ? EditAddressTheme.light()
        : EditAddressTheme.dark();

    return baseTheme.copyWith(
      iconColorPrimary: colorScheme.primary,
      iconColorSecondary: colorScheme.secondary,
      editAddressPageBackgroundColor: colorScheme.surface,
      editAddressWidgetColor: colorScheme.surfaceContainerLow,
      permanentAddressBlueLightColor: colorScheme.surfaceContainer,
      disabledFilledButtonBackgroundColor: colorScheme.outlineVariant,
    );
  }

  static LanguagePickerTheme _buildLanguagePickerTheme(
    DesignSystem designSystem,
  ) {
    final isLightTheme = designSystem.colors.brightness == Brightness.light;
    final colorScheme = designSystem.colors.colorScheme;
    final baseTheme = isLightTheme
        ? LanguagePickerTheme.light()
        : LanguagePickerTheme.dark();

    return baseTheme.copyWith(
      activeGradientEnd: colorScheme.primary,
      languageGradientStart: colorScheme.primary,
      languageGradientEnd: colorScheme.primary,
      activeButtonLanguageTextColor: colorScheme.onPrimary,
      buttonTextColor: colorScheme.onPrimary,
      filledButtonBackgroundColorDisabled: colorScheme.outlineVariant,
      disabledFilledButtonBackgroundColor: colorScheme.outlineVariant,
      bodyTextColor: colorScheme.onSurface,
      elevatedButtonForegroundColor: colorScheme.primary,
      elevatedButtonBackgroundColor: colorScheme.surfaceContainerLow,
      outlineButtonBackgroundColor: colorScheme.surfaceContainerLowest,
    );
  }
  {{#has_otp}}
  static SmsCodeTheme _buildSmsCodeTheme(DesignSystem designSystem) {
    final isLightTheme = designSystem.colors.brightness == Brightness.light;
    final colorScheme = designSystem.colors.colorScheme;
    final baseTheme = isLightTheme ? SmsCodeTheme.light() : SmsCodeTheme.dark();

    return baseTheme.copyWith(
      primaryColor: colorScheme.primary,
      defaultBackgroundColor: colorScheme.surfaceContainerLow,
      defaultBorderColor: colorScheme.outline,
      defaultTextStyle: baseTheme.defaultTextStyle?.copyWith(
        color: colorScheme.onSurface,
      ),
      disabledBackgroundColor: colorScheme.outlineVariant.withValues(
        alpha: isLightTheme ? 0.4 : 0.35,
      ),
      submittedBackgroundColor: colorScheme.surfaceContainer,
      resendButtonActiveTextColor: colorScheme.primary,
      resendButtonDisabledTextColor: colorScheme.onSurfaceVariant,
    );
  }{{/has_otp}}
  {{#enable_pin_code}}
  static PinCodeTheme _buildPinCodeTheme(DesignSystem designSystem) {
    final isLightTheme = designSystem.colors.brightness == Brightness.light;
    final colorScheme = designSystem.colors.colorScheme;
    final baseTheme = isLightTheme ? PinCodeTheme.light() : PinCodeTheme.dark();
    return baseTheme.copyWith(
      backgroundColor: colorScheme.surface,
      scaffoldBackgroundColor: colorScheme.surface,
      primaryColor: colorScheme.primary,
      primaryGradientStart: colorScheme.surface,
      primaryGradientEnd: colorScheme.surface,
      transparentColor: colorScheme.primary.withValues(alpha: 0.2),
      pinCodeKeyBackgroundColor: Color.alphaBlend(
        colorScheme.primary.withValues(alpha: isLightTheme ? 0.55 : 0.12),
        colorScheme.surface,
      ),
      pinCodeKeyTextColorPressed: colorScheme.primary,
      pinCodeKeyTextColorDefault: colorScheme.primary,
      pinKeyboardBottomButtonTextColor: colorScheme.primary,
      pinCodeErrorTextColor: isLightTheme
          ? designSystem.colors.anchorBlue
          : designSystem.colors.assertionYellow,
      appBarButtonIconColor: colorScheme.primary,
      pinKeyboardMaskedKeyBorderColor: colorScheme.primary,
      pinKeyboardMaskedKeyColor: colorScheme.primary,
    );
  }{{/enable_pin_code}}
  {{#enable_feature_qr_scanner}}
  static QrScannerTheme _buildQrScannerTheme(DesignSystem designSystem) {
    final isLightTheme = designSystem.colors.brightness == Brightness.light;
    final colorScheme = designSystem.colors.colorScheme;
    final baseTheme = isLightTheme
        ? QrScannerTheme.light()
        : QrScannerTheme.dark();

    return baseTheme.copyWith(
      qrScannerPageBackgroundColor: colorScheme.surface,
      qrScannerPageScaffoldBackgroundColor: colorScheme.surface,
      qrScannerPageAppBarBackgroundColor: colorScheme.surface,
      appBarBackgroundColor: colorScheme.surface,
      appBarTextColor: colorScheme.onSurface,
      backButtonColorMediumWhite: colorScheme.surfaceContainerLow,
      backButtonIconColor: colorScheme.onSurface,
      backButtonIconBorderColor: colorScheme.onSurface,
      qrScannerCameraPermissionBorderColor: colorScheme.primary,
      linearProgressIndicatorBackgroundColor: colorScheme.outlineVariant,
      qrScannerTextColor: colorScheme.onSurface,
      linearProgressIndicatorColor: colorScheme.primary,
    );
  }{{/enable_feature_qr_scanner}}
}
