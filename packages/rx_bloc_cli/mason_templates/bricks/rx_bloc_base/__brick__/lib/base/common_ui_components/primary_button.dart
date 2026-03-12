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
  Widget build(BuildContext context) {
    final colors = context.designSystem.colors.colorScheme;
    final spacing = context.designSystem.spacing;
    final effectiveStyle = (style ?? const ButtonStyle()).copyWith(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.primaryContainer.withValues(alpha: 0.5);
        }
        return colors.primaryContainer;
      }),
      foregroundColor: WidgetStateProperty.all(colors.onPrimaryContainer),
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(
          horizontal: spacing.m,
          vertical: spacing.s,
        ),
      ),
    );
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: effectiveStyle,
        onPressed: isLoading ? null : () => onPressed?.call(),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: KeyedSubtree(
            key: ValueKey(isLoading),
            child: _buildChildWidget(context),
          ),
        ),
      ),
    );
  }

  Widget _buildChildWidget(BuildContext context) {
    if (isLoading) {
      final indicator = SizedBox(
        width: loadingIndicatorSize,
        height: loadingIndicatorSize,
        child: AppLoadingIndicator.textButtonValue(
          context,
          color: context.designSystem.colors.colorScheme.onPrimaryContainer,
        ),
      );
      final label = child;
      if (label != null) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            indicator,
            SizedBox(width: context.designSystem.spacing.s),
            label,
          ],
        );
      }
      return indicator;
    }
    return child ?? const SizedBox();
  }
}
