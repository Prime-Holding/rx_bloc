// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.


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
