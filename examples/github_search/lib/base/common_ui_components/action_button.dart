import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class ActionButton extends StatelessWidget {
  /// Default constructor
  const ActionButton({
    required this.icon,
    required this.onPressed,
    this.disabled = false,
    this.tooltip = '',
    this.loading = false,
    Key? key,
  }) : super(key: key);

  /// The button disable state, which removes the [onPress] and sets a color
  final bool disabled;

  /// Loading flag that shows a loading indicator
  final bool loading;

  /// Text that describes the action that will occur when the button is pressed.
  final String tooltip;

  /// The icon to display. The available icons are described in [Icons].
  final Icon icon;

  /// The callback that is called when the button is tapped or
  /// otherwise activated.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: CircularProgressIndicator(),
      );
    }

    return FloatingActionButton(
      backgroundColor: disabled
          ? context.designSystem.colors.inactiveButtonColor
          : context.designSystem.colors.activeButtonColor,
      onPressed: !disabled ? onPressed : null,
      tooltip: tooltip,
      child: icon,
    );
  }
}
