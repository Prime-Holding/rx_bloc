import 'package:flutter/material.dart';

import 'design_system/design_system_color.dart';

class HotelAppTheme {
  static ThemeData buildTheme(DesignSystemColor designSystemColor) {
    final colorSchemeTheme = designSystemColor.brightness == Brightness.light
        ? ColorScheme.light()
        : ColorScheme.dark();
    final ColorScheme colorScheme = colorSchemeTheme.copyWith(
      primary: designSystemColor.primaryColor,
      secondary: designSystemColor.secondaryColor,
    );

    final ThemeData base = designSystemColor.brightness == Brightness.light
        ? ThemeData.light()
        : ThemeData.dark();

    return base.copyWith(
      colorScheme: colorScheme,
      // primaryColor: primaryColor,
      // buttonColor: primaryColor,
      indicatorColor: designSystemColor.indicatorColor,
      splashColor: designSystemColor.splashColor,
      splashFactory: InkRipple.splashFactory,
      // accentColor: secondaryColor,
      canvasColor: designSystemColor.canvasColor,
      backgroundColor: designSystemColor.backgroundColor,
      scaffoldBackgroundColor: designSystemColor.scaffoldBackgroundColor,
      errorColor: designSystemColor.errorColor,
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme),
      platform: TargetPlatform.iOS,
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    const String fontName = 'WorkSans';
    return base.copyWith(
      headline1: base.headline1!.copyWith(fontFamily: fontName),
      headline2: base.headline2!.copyWith(fontFamily: fontName),
      headline3: base.headline3!.copyWith(fontFamily: fontName),
      headline4: base.headline4!.copyWith(fontFamily: fontName),
      headline5: base.headline5!.copyWith(fontFamily: fontName),
      headline6: base.headline6!.copyWith(fontFamily: fontName),
      button: base.button!.copyWith(fontFamily: fontName),
      caption: base.caption!.copyWith(fontFamily: fontName),
      bodyText1: base.bodyText1!.copyWith(fontFamily: fontName),
      bodyText2: base.bodyText2!.copyWith(fontFamily: fontName),
      subtitle1: base.subtitle1!.copyWith(fontFamily: fontName),
      subtitle2: base.subtitle2!.copyWith(fontFamily: fontName),
      overline: base.overline!.copyWith(fontFamily: fontName),
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
      colorScheme: colorScheme,
      // primaryColor: primaryColor,
      // buttonColor: primaryColor,
      indicatorColor: Colors.white,
      splashColor: Colors.white24,
      splashFactory: InkRipple.splashFactory,
      // accentColor: secondaryColor,
      canvasColor: Colors.white,
      backgroundColor: const Color(0xFFFFFFFF),
      scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      errorColor: const Color(0xFFB00020),
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme),
      platform: TargetPlatform.iOS,
    );
  }
}

class _HexColor extends Color {
  _HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
