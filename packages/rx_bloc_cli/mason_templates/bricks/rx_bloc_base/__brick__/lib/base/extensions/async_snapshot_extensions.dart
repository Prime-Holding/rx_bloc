{{> licence.dart }}

import 'package:flutter/material.dart';

import '../theme/design_system.dart';

extension AsyncSnapshotLoadingState on AsyncSnapshot<bool> {
  /// The loading state extracted from the snapshot
  bool get isLoading => hasData && data!;

  /// The color based on the isLoading state
  Color getButtonColor(BuildContext context) => isLoading
      ? context.designSystem.colors.inactiveButtonColor
      : context.designSystem.colors.activeButtonColor;
}
