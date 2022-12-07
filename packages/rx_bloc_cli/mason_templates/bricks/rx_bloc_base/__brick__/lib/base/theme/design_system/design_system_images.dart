{{> licence.dart }}

import 'package:flutter/material.dart';

@immutable
class DesignSystemImages {
  const DesignSystemImages();

  static const imagePath = 'assets/images';

  final testImage = const AssetImage('$imagePath/testImage.png');
}
