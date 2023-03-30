{{> licence.dart }}

import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_loading_indicator.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.child,
    required this.isLoading,
    required this.backgroundColor,
    required this.text,
    this.onPressed,
    this.elevation = 2.0,
    this.height = 36.0,
    this.padding = const EdgeInsets.all(0),
    this.width = 220,
    this.splashColor = Colors.white30,
    this.highlightColor = Colors.white30,
    this.innerPadding = const EdgeInsets.fromLTRB(12, 0, 0, 0),
    this.textStyle,
    this.shape,
  });
  final Function()? onPressed;
  final Color backgroundColor;
  final double elevation;
  final double height;
  final EdgeInsetsGeometry? padding;
  final String text;
  final double width;
  final Color splashColor;
  final Color highlightColor;
  final EdgeInsetsGeometry innerPadding;
  final Widget child;
  final bool isLoading;
  final TextStyle? textStyle;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      key: key,
      height: height,
      elevation: elevation,
      padding: padding,
      color: backgroundColor,
      onPressed: onPressed,
      disabledElevation: elevation,
      disabledColor: backgroundColor,
      splashColor: Colors.white30,
      highlightColor: Colors.white30,
      shape: shape ?? ButtonTheme.of(context).shape,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: width,
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: innerPadding,
                child: Container(
                  width: 36,
                  margin: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: isLoading ? child : _proggressIndicator(context),
                  ),
                ),
              ),
              Text(text,
                  style: textStyle ?? context.designSystem.typography.h3Med14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _proggressIndicator(BuildContext context) => AppLoadingIndicator(
        padding: EdgeInsets.all(context.designSystem.spacing.xss1),
        size: Size(height, height),
      );
}
