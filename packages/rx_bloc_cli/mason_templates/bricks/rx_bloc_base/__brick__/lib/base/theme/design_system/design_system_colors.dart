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
        scaffoldBackgroundColor = Colors.white,
        updateIconAppBarColor = Colors.black,
        textButtonColor = const Color.fromRGBO(0, 0, 0, 0.54),
        dividerColor = const Color(0xff808080){{#enable_social_logins}},
        appleBackground = const Color(0xFF000000),
        googleBackground = const Color(0xFFFFFFFF),
        facebookBackground = const Color(0xFF1877F2){{/enable_social_logins}};

  const DesignSystemColors.dark()
      : brightness = Brightness.dark,
        primaryColor = const Color(0xffce93d8),
        backgroundColor = Colors.black,
        scaffoldBackgroundColor = Colors.black,
        updateIconAppBarColor = Colors.white,
        textButtonColor = const Color(0xFFFFFFFF),
        dividerColor = const Color(0xff808080){{#enable_social_logins}},
        appleBackground = const Color(0xFFFFFFFF),
        googleBackground = Colors.black,
        facebookBackground = const Color(0xFFFFFFFF){{/enable_social_logins}};

  final Brightness brightness;

  /// region Essential (Material and component) colors

  final Color primaryColor;

  final Color backgroundColor;

  final Color scaffoldBackgroundColor;

  final Color dividerColor;

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

  final Color messageColor = Colors.black87;

  final Color tintColor = const Color(0xff808080);

  final Color updateIconAppBarColor;

  final Color textButtonColor;

  final Color transparent = Colors.transparent;
  {{#enable_social_logins}}
  final Color appleBackground;

  final Color facebookBackground;

  final Color googleBackground;

  final Color socialLoginBorderColor = Colors.white;
  {{/enable_social_logins}}{{#enable_pin_code}}
  final Color pinAppBarColor = Colors.white;
  {{/enable_pin_code}}{{#enable_profile}}
  final Color circleAvatarColor = Colors.white;
  {{/enable_profile}}{{#enable_feature_otp}}
//otp colors
  final Color pinBgColor = const Color(0xE5EEEEEE);

  final Color pinBgDisabledColor = const Color(0xFF9D9D9D);

  final pinBgSuccessColor = const Color.fromRGBO(102, 240, 174, .5);

  final pinErrorBorderColor = Colors.red;

  final pinBgSubmittedColor = const Color.fromRGBO(222, 231, 240, .7);
{{/enable_feature_otp}}{{#has_otp}}

  final Color pinSuccessBorderColor = Colors.green;{{/has_otp}}

  ///
}
