import 'package:flutter/material.dart';

class RxInputDecorationData {
  const RxInputDecorationData({
    this.cursorColor = const Color(0xff333333),
    this.focusedErrorBorderColor = const Color(0xffff6b2a),
    this.errorBorderColor = const Color(0xffff6b2a),
    this.focusedBorderColor = const Color(0xff04c9eb),
    this.enabledBorderColor = const Color(0xffdfdfdf),
    this.fillColor = const Color(0xffebecf2),
    this.errorStyle = const TextStyle(
      color: const Color(0xffff6b2a),
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
      fontStyle: FontStyle.normal,
      fontSize: 12,
    ),
    this.labelStyle = const TextStyle(
      color: Color(0xff333333),
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
      fontStyle: FontStyle.normal,
      fontSize: 14,
    ),
    this.labelStyleError = const TextStyle(
      color: const Color(0xffff6b2a),
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
      fontStyle: FontStyle.normal,
      fontSize: 14,
    ),
    this.iconVisibility = const Icon(Icons.visibility),
    this.iconVisibilityOff = const Icon(Icons.visibility_off),
    this.prefixIcon,
    this.label,
  });

  final Color cursorColor; // = Color(0xff333333);

  final Color focusedErrorBorderColor;

  final Color errorBorderColor;

  final Color focusedBorderColor;

  final Color enabledBorderColor;

  final Color fillColor;

  final TextStyle errorStyle;

  final TextStyle labelStyle;

  final TextStyle labelStyleError;

  final Widget iconVisibility;

  final Widget iconVisibilityOff;

  final Widget prefixIcon;

  final String label;
}
