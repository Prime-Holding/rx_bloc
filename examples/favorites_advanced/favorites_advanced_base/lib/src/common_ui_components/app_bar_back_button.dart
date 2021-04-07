import 'package:flutter/material.dart';

import 'icon_with_shadow.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const IconWithShadow(icon: Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      );
}
