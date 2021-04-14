import 'package:favorites_advanced_base/src/theme/design_system/design_system_typography.dart';
import 'package:flutter/material.dart';

import '../../../core.dart';
import 'design_system_color.dart';

class DesignSystem {
  final DesignSystemColor colors;
  final DesignSystemTypography typography;

  DesignSystem({
    required this.colors,
    required this.typography,
  });

  factory DesignSystem.fromBrightness(
      BuildContext context, Brightness brightness) {
    return DesignSystem._create(context, brightness);
  }

  static DesignSystem of<T>(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return DesignSystem._create(context, brightness);
  }

  static DesignSystem _create(BuildContext context, Brightness brightness) {
    final designSystemColor = DesignSystemColor(brightness: brightness);
    final designSystemTypography =
        DesignSystemTypography.withColor(designSystemColor);

    return DesignSystem(
      colors: designSystemColor,
      typography: designSystemTypography,
    );
  }

  ThemeData get theme => HotelAppTheme.buildTheme(this);
}
