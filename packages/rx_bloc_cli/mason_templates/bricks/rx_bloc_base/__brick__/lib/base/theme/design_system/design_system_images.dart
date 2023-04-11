{{> licence.dart }}

import 'package:flutter/material.dart';

@immutable
class DesignSystemImages {
  const DesignSystemImages.dark(){{#enable_social_logins}}
      : googleLogo = '$imagePath/google_dark_icon.svg'{{/enable_social_logins}};
  const DesignSystemImages.light(){{#enable_social_logins}}
      : googleLogo = '$imagePath/google_light_icon.svg'{{/enable_social_logins}};
      
  static const imagePath = 'assets/images';
  final testImage = const AssetImage('$imagePath/testImage.png');
  {{#enable_social_logins}}
  final String googleLogo;

  final String appleLogo = '$imagePath/apple_icon.svg';

  final String facebookLogo = '$imagePath/facebook_icon.svg';
  {{/enable_social_logins}}
}
