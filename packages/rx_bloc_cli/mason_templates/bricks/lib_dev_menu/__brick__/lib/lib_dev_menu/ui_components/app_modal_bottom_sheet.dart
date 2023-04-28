import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app_extensions.dart';

const heightFactorLarge = 0.9;
bool isBottomSheetShown = false;

Future<T?> showAppModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  WidgetBuilder? headerBuilder,
  VoidCallback? onDonePressed,
  VoidCallback? onCancelPressed,
  double? heightFactor,
  bool hideCloseButton = false,
  bool applySafeArea = true,
  bool safeAreaBottom = true,
  bool hideTheLine = false,
  bool isDismissible = true,
  bool haveOnlyOneSheet = true,
}) {
  if (haveOnlyOneSheet) {
    if (isBottomSheetShown) {
      Navigator.pop(context);
    }

    isBottomSheetShown = true;
  }
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    barrierColor: context.designSystem.colors.scaffoldBackgroundColor,
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    elevation: 0,
    builder: (context) => TweenAnimationBuilder<double>(
      builder: (context, sigma, child) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: child,
      ),
      duration: const Duration(milliseconds: 200),
      tween: Tween(begin: 0.0, end: 5.0),
      child: _AppModalBottomSheet(
        heightFactor: heightFactor,
        builder: builder,
        onCancelPressed: onCancelPressed,
        headerBuilder: headerBuilder,
        hideCloseButton: hideCloseButton,
        hideTheLine: hideTheLine,
        onDonePressed: onDonePressed,
        applySafeArea: applySafeArea,
        safeAreaBottom: safeAreaBottom,
      ),
    ),
  ).then((value) {
    isBottomSheetShown = false;
    return value;
  });
}

class _AppModalBottomSheet extends StatelessWidget {
  final double? heightFactor;
  final WidgetBuilder builder;
  final VoidCallback? onCancelPressed;
  final WidgetBuilder? headerBuilder;
  final bool hideCloseButton;
  final bool hideTheLine;
  final VoidCallback? onDonePressed;
  final bool applySafeArea;
  final bool safeAreaBottom;

  const _AppModalBottomSheet({
    Key? key,
    required this.builder,
    required this.hideCloseButton,
    required this.hideTheLine,
    this.heightFactor,
    this.onCancelPressed,
    this.headerBuilder,
    this.onDonePressed,
    this.applySafeArea = true,
    this.safeAreaBottom = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => heightFactor == null
      ? Wrap(
          children: [_buildContent(context)],
        )
      : FractionallySizedBox(
          heightFactor: heightFactor,
          child: _buildContent(context),
        );

  Widget _buildContent(BuildContext context) {
    final widget = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context),
        heightFactor != null
            ? Expanded(child: builder(context))
            : builder(context),
      ],
    );

    if (applySafeArea) {
      return Container(
        decoration: _buildDecoration(context),
        child: SafeArea(
          bottom: safeAreaBottom,
          child: widget,
        ),
      );
    }

    return widget;
  }

  Widget _buildHeader(BuildContext context) => Container(
        height: (headerBuilder != null || !hideCloseButton)
            ? 72
            : (!hideTheLine)
                ? 10
                : 0,
        decoration: _buildDecoration(context),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (!hideTheLine)
              Positioned.fill(
                top: 6,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.designSystem.colors.gray,
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                ),
              ),
            if (headerBuilder != null)
              Positioned(
                child: headerBuilder != null
                    ? Padding(
                        padding: EdgeInsets.only(
                          left: context.designSystem.spacing.xl,
                        ),
                        child: headerBuilder?.call(context),
                      )
                    : const SizedBox(),
              ),
            if (!hideCloseButton)
              Positioned(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: context.designSystem.spacing.xss,
                      ),
                      child: IconButton(
                        onPressed: () {
                          onCancelPressed?.call();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.cancel_outlined),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );

  BoxDecoration _buildDecoration(BuildContext context) => BoxDecoration(
        color: context.designSystem.colors.gray,
        border: Border.all(
          color: context.designSystem.colors.snow,
          width: 0,
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(context.designSystem.spacing.xl),
          topLeft: Radius.circular(context.designSystem.spacing.xl),
        ),
      );
}
