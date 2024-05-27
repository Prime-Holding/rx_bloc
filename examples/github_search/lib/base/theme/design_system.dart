// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

import 'design_system/design_system_colors.dart';
import 'design_system/design_system_icons.dart';
import 'design_system/design_system_images.dart';
import 'design_system/design_system_spacing.dart';
import 'design_system/design_system_typography.dart';

@immutable
class DesignSystem extends ThemeExtension<DesignSystem> {
  const DesignSystem({
    required this.colors,
    required this.icons,
    required this.typography,
    required this.images,
    required this.spacing,
  });

  DesignSystem.light()
      : colors = const DesignSystemColors.light(),
        icons = DesignSystemIcons(),
        images = const DesignSystemImages.light(),
        spacing = const DesignSystemSpacing(),
        typography =
            DesignSystemTypography.withColor(const DesignSystemColors.light());

  DesignSystem.dark()
      : colors = const DesignSystemColors.dark(),
        icons = DesignSystemIcons(),
        images = const DesignSystemImages.dark(),
        spacing = const DesignSystemSpacing(),
        typography =
            DesignSystemTypography.withColor(const DesignSystemColors.dark());

  final DesignSystemColors colors;
  final DesignSystemIcons icons;
  final DesignSystemTypography typography;
  final DesignSystemImages images;
  final DesignSystemSpacing spacing;

  @override
  ThemeExtension<DesignSystem> copyWith({
    DesignSystemColors? colors,
    DesignSystemIcons? icons,
    DesignSystemTypography? typography,
    DesignSystemImages? images,
    DesignSystemSpacing? spacing,
  }) =>
      DesignSystem(
        colors: colors ?? this.colors,
        icons: icons ?? this.icons,
        typography: typography ?? this.typography,
        images: images ?? this.images,
        spacing: spacing ?? this.spacing,
      );

  @override
  ThemeExtension<DesignSystem> lerp(
          ThemeExtension<DesignSystem>? other, double t) =>
      t < 1.0 ? this : (other ?? this);
}

/// Extension to enable quick access of design system via a build context
extension DesignSystemContextExtension on BuildContext {
  /// Returns a reference to the [DesignSystem] theme extension of the current [Theme]
  DesignSystem get designSystem => Theme.of(this).extension<DesignSystem>()!;
}
