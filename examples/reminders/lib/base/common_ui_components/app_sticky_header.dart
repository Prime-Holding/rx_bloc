import 'package:flutter/widgets.dart';

import '../theme/design_system.dart';

class AppStickyHeader extends StatelessWidget {
  const AppStickyHeader({
    required this.text,
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) => Container(
        height: 45,
        color: context.designSystem.colors.backgroundHeader,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: context.designSystem.typography.subtitle1,
        ),
      );
}
