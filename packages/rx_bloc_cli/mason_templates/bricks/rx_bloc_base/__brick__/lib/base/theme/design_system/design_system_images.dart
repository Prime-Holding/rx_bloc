{{> licence.dart }}

import 'package:flutter/material.dart';

@immutable
class DesignSystemImages {
  {{#enable_social_logins}}
  const DesignSystemImages.dark()
      : googleLogo = '$imagePath/google_dark_icon.svg';
  const DesignSystemImages.light()
      : googleLogo = '$imagePath/google_light_icon.svg';
  {{/enable_social_logins}}
  {{^enable_social_logins}}
  const DesignSystemImages();
  {{/enable_social_logins}}
  static const imagePath = 'assets/images';
  final testImage = const AssetImage('$imagePath/testImage.png');
  {{#enable_social_logins}}
  final String googleLogo;

  final String appleLogo = '$imagePath/apple_icon.svg';

  final String facebookLogo = '$imagePath/facebook_icon.svg';
  {{/enable_social_logins}}
}
