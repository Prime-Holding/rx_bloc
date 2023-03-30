{{> licence.dart }}

import 'package:flutter/material.dart';

@immutable
class DesignSystemImages {
  const DesignSystemImages();

  static const imagePath = 'assets/images';
  final testImage = const AssetImage('$imagePath/testImage.png');
  {{#enable_social_logins}}
  final String googleDarkLogo = '$imagePath/google_dark_icon.svg';

  final String googleLightLogo = '$imagePath/google_light_icon.svg';

  final String appleLogo = '$imagePath/apple_icon.svg';

  final String facebookLogo = '$imagePath/facebook_icon.svg';
  {{/enable_social_logins}}
}
