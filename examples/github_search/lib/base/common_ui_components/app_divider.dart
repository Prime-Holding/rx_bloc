import 'package:flutter/material.dart';

import '../../app_extensions.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: context.designSystem.spacing.s,
      endIndent: context.designSystem.spacing.s,
      thickness: 0.4,
    );
  }
}
