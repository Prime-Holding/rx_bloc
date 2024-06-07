// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

import '../theme/design_system.dart';
import 'app_loading_indicator.dart';

class ActionButton extends StatelessWidget {
  /// Default constructor for the action button
  const ActionButton({
    required this.icon,
    required this.onPressed,
    this.tooltip = '',
    this.loading = false,
    this.heroTag,
    this.appLoadingIndicatorKey,
    this.floatingActionButtonKey,
    super.key,
  });

  /// Loading flag that shows a loading indicator
  final bool loading;

  /// Text that describes the action that will occur when the button is pressed.
  final String tooltip;

  /// The icon to display. The available icons are described in [Icons].
  final Icon icon;

  final Object? heroTag;

  /// The callback that is called when the button is tapped or
  /// otherwise activated.
  final VoidCallback? onPressed;

  final Key? appLoadingIndicatorKey;
  final Key? floatingActionButtonKey;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.designSystem.spacing.xs1,
        ),
        child: AppLoadingIndicator.innerCircleValue(
            context, appLoadingIndicatorKey),
      );
    }

    return FloatingActionButton(
      key: floatingActionButtonKey,
      backgroundColor: onPressed == null
          ? context.designSystem.colors.inactiveButtonColor
          : context.designSystem.colors.activeButtonColor,
      onPressed: onPressed,
      tooltip: tooltip,
      heroTag: heroTag,
      child: icon,
    );
  }
}
