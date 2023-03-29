{{> licence.dart }}

import 'package:flutter/material.dart';

// Material Design System documentation.
// https://m2.material.io/design/color/the-color-system.html
// https://m2.material.io/design/color/dark-theme.html

@immutable
class DesignSystemColors {
  const DesignSystemColors.light()
      : brightness = Brightness.light,
        primaryColor = const Color(0xff2196f3),
        backgroundColor = Colors.white,
        scaffoldBackgroundColor = Colors.white;

  const DesignSystemColors.dark()
      : brightness = Brightness.dark,
        primaryColor = const Color(0xffce93d8),
        backgroundColor = Colors.black,
        scaffoldBackgroundColor = Colors.black;

  final Brightness brightness;

  /// region Essential (Material and component) colors

  final Color primaryColor;

  final Color backgroundColor;

  final Color scaffoldBackgroundColor;

  final errorColor = Colors.red;

  /// endregion

  /// region App-specific colors

  final inactiveButtonColor = Colors.blueGrey;

  final activeButtonColor = Colors.blue;

  final inactiveButtonTextColor = Colors.grey;

  final activeButtonTextColor = Colors.white;

  final progressIndicatorBackgroundColor = Colors.white;

  /// endregion

  /// region General purpose colors

  final blanchedAlmond = const Color(0xffffebcd);

  final darkSeaGreen = const Color(0xff8fbc8f);

  final snow = const Color(0xfffffafa);

  final black = Colors.black87;

  final gray = const Color(0xff808080);
  {{#enable_social_logins}}
  final googleBackgroundLight = const Color(0xFFFFFFFF);

  final googleBackgroundDark = const Color(0xFF4285F4);

  final googleTextLight = const Color.fromRGBO(0, 0, 0, 0.54);

  final googleTextDark = const Color(0xFFFFFFFF);

  final googleButtonTextBackground = const Color.fromARGB(0, 0, 0, 0);
  {{/enable_social_logins}}
  ///
}
