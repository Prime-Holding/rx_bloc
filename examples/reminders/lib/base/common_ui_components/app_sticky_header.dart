import 'package:flutter/widgets.dart';

import '../theme/design_system.dart';

class AppStickyHeader extends StatelessWidget {
  const AppStickyHeader({
    required this.text,
    this.color,
    Key? key,
  }) : super(key: key);

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
