import 'package:favorites_advanced_base/src/theme/design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../core.dart';
import 'design_system_color.dart';

class DesignSystemOptions {
  static DesignSystem of<T>(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final designSystemColor = DesignSystemColor(brightness);

    return DesignSystem(colors: designSystemColor);
  }

  static DesignSystem build(BuildContext context, Brightness brightness) {
    final designSystemColor = DesignSystemColor(brightness);

    return DesignSystem(colors: designSystemColor);
  }
}
