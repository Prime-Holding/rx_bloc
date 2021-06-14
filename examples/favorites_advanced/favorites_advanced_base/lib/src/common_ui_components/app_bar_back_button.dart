import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';

import 'icon_with_shadow.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
        icon: IconWithShadow(icon: DesignSystem.of(context).icons.arrowBack),
        onPressed: () => Navigator.of(context).pop(),
      );
}
