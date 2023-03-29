{{> licence.dart }}

import 'package:flutter/material.dart';

@immutable
class DesignSystemImages {
  const DesignSystemImages();

  static const imagePath = 'assets/images';
  final testImage = const AssetImage('$imagePath/testImage.png');
  {{#enable_social_logins}}
  final googleDarkLogo = const AssetImage('$imagePath/google_dark.png');

  final googleLightLogo = const AssetImage('$imagePath/google_light.png');
  {{/enable_social_logins}}
}
