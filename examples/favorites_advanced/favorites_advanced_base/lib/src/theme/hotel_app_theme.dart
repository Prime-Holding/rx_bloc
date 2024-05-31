import 'package:flutter/material.dart';

class HotelAppTheme {
  static TextTheme _buildTextTheme(TextTheme base) {
    const String fontName = 'WorkSans';
    return base.copyWith(
      displayLarge: base.displayLarge!.copyWith(fontFamily: fontName),
      displayMedium: base.displayMedium!.copyWith(fontFamily: fontName),
      displaySmall: base.displaySmall!.copyWith(fontFamily: fontName),
      headlineMedium: base.headlineMedium!.copyWith(fontFamily: fontName),
      headlineSmall: base.headlineSmall!.copyWith(fontFamily: fontName),
      titleLarge: base.titleLarge!.copyWith(fontFamily: fontName),
      labelLarge: base.labelLarge!.copyWith(fontFamily: fontName),
      bodySmall: base.bodySmall!.copyWith(fontFamily: fontName),
      bodyLarge: base.bodyLarge!.copyWith(fontFamily: fontName),
      bodyMedium: base.bodyMedium!.copyWith(fontFamily: fontName),
      titleMedium: base.titleMedium!.copyWith(fontFamily: fontName),
      titleSmall: base.titleSmall!.copyWith(fontFamily: fontName),
      labelSmall: base.labelSmall!.copyWith(fontFamily: fontName),
    );
  }

  static ThemeData buildLightTheme() {
    // final Color primaryColor = _HexColor('#54D3C2');
    // final Color secondaryColor = _HexColor('#54D3C2');
    final ColorScheme colorScheme = const ColorScheme.light().copyWith(
        // primary: primaryColor,
        // secondary: secondaryColor,
        );
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      indicatorColor: Colors.white,
      splashColor: Colors.white24,
      splashFactory: InkRipple.splashFactory,
      // accentColor: secondaryColor,
      canvasColor: Colors.white,
      scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      cardColor: const Color(0xFFB00020),
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),

      //  accentTextTheme: _buildTextTheme(base.accentTextTheme),
      platform: TargetPlatform.iOS, colorScheme: colorScheme.copyWith(surface: const Color(0xFFFFFFFF)),
    );
  }
}
