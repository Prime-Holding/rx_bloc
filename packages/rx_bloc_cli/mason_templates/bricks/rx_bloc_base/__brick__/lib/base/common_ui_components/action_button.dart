{{> licence.dart }}

import 'package:flutter/material.dart';

import '../theme/design_system.dart';
import 'app_loading_indicator.dart';

class ActionButton extends StatelessWidget {
  /// Default constructor
  const ActionButton({
    required this.icon,
    required this.onPressed,
    this.tooltip = '',
    this.loading = false,
    this.heroTag,
    Key? key,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: AppLoadingIndicator.innerCircleValue(context),
      );
    }

    return FloatingActionButton(
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
