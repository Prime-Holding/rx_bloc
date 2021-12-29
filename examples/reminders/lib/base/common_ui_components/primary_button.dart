// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.


import 'package:flutter/material.dart';

import '../theme/design_system.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    this.onPressed,
    this.child,
    this.isLoading = false,
    this.loadingIndicatorSize = 20,
    Key? key,
  }) : super(key: key);

  final bool isLoading;
  final Widget? child;
  final Function? onPressed;
  final double loadingIndicatorSize;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        onPressed: () => isLoading ? null : onPressed?.call(),
        child: _buildChildWidget(context),
      );

  Widget _buildChildWidget(BuildContext context) => isLoading
      ? SizedBox(
          width: loadingIndicatorSize,
          height: loadingIndicatorSize,
          child: CircularProgressIndicator.adaptive(
            backgroundColor:
                context.designSystem.colors.progressIndicatorBackgroundColor,
          ),
        )
      : child ?? const SizedBox();
}
