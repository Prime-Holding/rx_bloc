{{> licence.dart }}

import 'package:flutter/material.dart';

import '../theme/design_system.dart';
import 'app_loading_indicator.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    this.onPressed,
    this.child,
    this.isLoading = false,
    this.loadingIndicatorSize = 20,
    this.style,
    super.key,
  });

  final bool isLoading;
  final Widget? child;
  final Function? onPressed;
  final double loadingIndicatorSize;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: style,
        onPressed: () => isLoading ? null : onPressed?.call(),
        child: _buildChildWidget(context),
      );

  Widget _buildChildWidget(BuildContext context) => isLoading
      ? SizedBox(
          width: loadingIndicatorSize,
          height: loadingIndicatorSize,
          child: AppLoadingIndicator.textButtonValue(
            context,
            color: context.designSystem.colors.progressIndicatorBackgroundColor,
          ),
        )
      : child ?? const SizedBox();
}
