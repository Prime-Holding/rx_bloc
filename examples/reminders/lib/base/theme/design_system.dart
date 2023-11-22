// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

import 'design_system/design_system_colors.dart';
import 'design_system/design_system_icons.dart';
import 'design_system/design_system_images.dart';
import 'design_system/design_system_typography.dart';
import 'reminders_theme.dart';

/// The main design system class containing all the design system components in
/// one place. It is used to build the theme for the app.
class DesignSystem {
  /// Design system constructor taking in the [colors], [icons], [typography],
  /// and [images]
  DesignSystem({
    required this.colors,
    required this.icons,
    required this.typography,
    required this.images,
  });

  /// Factory constructor building the design system based on the app brightness
  /// (light/dark mode)
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

  /// Static method to retrieve the design system with the same brightness as
  /// in the provided [context]
  static DesignSystem of<T>(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return DesignSystem._(brightness);
  }

  /// The design system colors
  final DesignSystemColors colors;

  /// All the icons used in the app
  final DesignSystemIcon icons;

  /// The design system typography
  final DesignSystemTypography typography;

  /// The design system images
  final DesignSystemImages images;

  /// Builds the theme for the reminders app
  ThemeData get theme => RemindersTheme.buildTheme(this);
}

/// Extension to enable quick access of design system via a build context
extension BuildContextExtension on BuildContext {
  /// Retrieves the design system from the build context
  DesignSystem get designSystem => DesignSystem.of(this);
}
