{{> licence.dart }}

import 'package:flutter/material.dart';

import '../theme/design_system.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    this.alignment = Alignment.center,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.size = const Size(68, 68),
    this.strokeWidth = 3,
    this.color,
    Key? key,
  }) : super(key: key);

  factory AppLoadingIndicator.innerCircleValue(BuildContext context) =>
      const AppLoadingIndicator(
        padding: EdgeInsets.zero,
        size: Size(20, 20),
        strokeWidth: 1.5,
      );

  factory AppLoadingIndicator.textButtonValue({Color? color}) =>
      AppLoadingIndicator(
        padding: EdgeInsets.zero,
        size: const Size(20, 20),
        strokeWidth: 2,
        color: color,
      );

  factory AppLoadingIndicator.taskValue({required Color color}) =>
      AppLoadingIndicator(
        padding: EdgeInsets.zero,
        strokeWidth: 2,
        size: const Size(32, 32),
        color: color,
      );

  final Alignment alignment;
  final EdgeInsets padding;
  final Size size;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
    alignment: alignment,
    padding: padding,
    width: size.width,
    height: size.height,
    child: CircularProgressIndicator(
      color: color ?? context.designSystem.colors.primaryColor,
      strokeWidth: strokeWidth,
    ),
  );
}
