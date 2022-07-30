{{> licence.dart }}

import 'package:flutter/material.dart';

import 'design_system/design_system_colors.dart';
import 'design_system/design_system_icons.dart';
import 'design_system/design_system_images.dart';
import 'design_system/design_system_typography.dart';
import '{{project_name}}_theme.dart';

class DesignSystem {
  DesignSystem({
    required this.colors,
    required this.icons,
    required this.typography,
    required this.images,
  });

  factory DesignSystem.fromBrightness(Brightness brightness) =>
      DesignSystem._(brightness);

  factory DesignSystem._(Brightness brightness) {
    final designSystemColors = DesignSystemColors(brightness: brightness);
    final designSystemTypography =
        DesignSystemTypography.withColor(designSystemColors);
    final designSystemIcons = DesignSystemIcon();
    final designSystemImages = DesignSystemImages();

    return DesignSystem(
      colors: designSystemColors,
      typography: designSystemTypography,
      icons: designSystemIcons,
      images: designSystemImages,
    );
  }

  static DesignSystem of<T>(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return DesignSystem._(brightness);
  }

  final DesignSystemColors colors;
  final DesignSystemIcon icons;
  final DesignSystemTypography typography;
  final DesignSystemImages images;

  ThemeData get theme => {{#pascalCase}}{{project_name}}{{/pascalCase}}Theme.buildTheme(this);
}

/// Extension to enable quick access of design system via a build context
extension BuildContextExtension on BuildContext {
  DesignSystem get designSystem => DesignSystem.of(this);
}
