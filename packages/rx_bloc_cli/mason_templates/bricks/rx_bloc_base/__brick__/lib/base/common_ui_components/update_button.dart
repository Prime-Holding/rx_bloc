import 'package:flutter/material.dart';

import '../../base/theme/design_system.dart';
import '../../l10n/l10n.dart';

class UpdateButton extends StatelessWidget {
  const UpdateButton({
    required bool isActive,
    required VoidCallback onPressed,
    Key? key,
  })  : _isActive = isActive,
        _onPressed = onPressed,
        super(key: key);

  final VoidCallback _onPressed;

  final bool _isActive;

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: _isActive ? _onPressed : null,
        icon: Icon(context.designSystem.icons.reload),
        tooltip: context.l10n.reload,
        color: _isActive
            ? context.designSystem.colors.activeButtonTextColor
            : context.designSystem.colors.inactiveButtonTextColor,
      );
}
