import 'package:flutter/cupertino.dart';

import '../theme/design_system.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.designSystem.typography.h1Bold20,
    );
  }
}
