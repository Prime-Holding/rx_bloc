import 'package:flutter/widgets.dart';

import '../theme/design_system.dart';

/// Widget that displays a container with a text header, with customizable text
/// and background color, and uses the design system from the context for
/// styling. Intended to be used as a sticky header in a list.
class AppStickyHeader extends StatelessWidget {
  const AppStickyHeader({
    required this.text,
    this.color,
    super.key,
  });

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
        height: 45,
        color: color ?? context.designSystem.colors.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: context.designSystem.typography.stickyHeader,
        ),
      );
}
