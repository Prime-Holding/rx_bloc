// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

import '../theme/design_system.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    this.alignment = Alignment.center,
    this.padding,
    this.size,
    this.strokeWidth,
    this.color,
    super.key,
  });

  final Alignment? alignment;
  final EdgeInsets? padding;
  final Size? size;
  final double? strokeWidth;
  final Color? color;

  factory AppLoadingIndicator.innerCircleValue(
          BuildContext context, Key? appLoadingkey) =>
      AppLoadingIndicator(
        key: appLoadingkey,
        padding: EdgeInsets.zero,
        size: Size(
          context.designSystem.spacing.xxl2,
          context.designSystem.spacing.xxl2,
        ),
        strokeWidth: 4,
      );

  factory AppLoadingIndicator.textButtonValue(BuildContext context,
          {Color? color}) =>
      AppLoadingIndicator(
        padding: EdgeInsets.zero,
        size: Size(
          context.designSystem.spacing.l,
          context.designSystem.spacing.l,
        ),
        strokeWidth: 2,
        color: color,
      );

  factory AppLoadingIndicator.taskValue(BuildContext context, {Color? color}) =>
      AppLoadingIndicator(
        padding: EdgeInsets.zero,
        strokeWidth: 4,
        size: Size(
          context.designSystem.spacing.xxl,
          context.designSystem.spacing.xxl,
        ),
        color: color ?? context.designSystem.colors.primaryColor,
      );

  @override
  Widget build(BuildContext context) => Container(
        alignment: alignment ?? Alignment.center,
        padding: padding ??
            EdgeInsets.symmetric(
              vertical: context.designSystem.spacing.m,
            ),
        width: size?.width ?? context.designSystem.spacing.xxxxl2,
        height: size?.height ?? context.designSystem.spacing.xxxxl2,
        child: CircularProgressIndicator(
          color: color ?? context.designSystem.colors.primaryColor,
          strokeWidth: strokeWidth ?? context.designSystem.spacing.xsss,
        ),
      );
}
