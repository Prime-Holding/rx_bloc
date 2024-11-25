import 'package:flutter/material.dart';

import '../theme/design_system.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) => Divider(
        thickness: 0.3,
        height: context.designSystem.spacing.m,
        indent: context.designSystem.spacing.m,
        endIndent: context.designSystem.spacing.m,
      );
}
