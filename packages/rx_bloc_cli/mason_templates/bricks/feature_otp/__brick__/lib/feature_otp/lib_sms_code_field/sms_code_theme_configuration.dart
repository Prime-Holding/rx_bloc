import 'package:flutter/material.dart';

/// Sms theme config class containing styling for different pin field states
class SmsThemeConfiguration {
  const SmsThemeConfiguration({
    this.defaultStyle,
    this.errorStyle,
    this.successStyle,
    this.disabledStyle,
    this.focusedStyle,
    this.submittedStyle,
    this.unfilledStyle,
  });

  /// Default state of the sms fields
  final SmsFieldTheme? defaultStyle;

  /// Style of the sms fields when in error state
  final SmsFieldTheme? errorStyle;

  /// Style of the sms fields after successful confirmation
  final SmsFieldTheme? successStyle;

  /// Style of the sms fields when disabled
  final SmsFieldTheme? disabledStyle;

  /// Style of the currently focused sms field
  final SmsFieldTheme? focusedStyle;

  /// Style of the sms fields when they are submitted/filled
  final SmsFieldTheme? submittedStyle;

  /// Style of the sms fields which are empty (not yet submitted/filled)
  final SmsFieldTheme? unfilledStyle;

  SmsThemeConfiguration copyWith({
    SmsFieldTheme? defaultStyle,
    SmsFieldTheme? errorStyle,
    SmsFieldTheme? successStyle,
    SmsFieldTheme? disabledStyle,
    SmsFieldTheme? focusedStyle,
    SmsFieldTheme? submittedStyle,
    SmsFieldTheme? unfilledStyle,
  }) =>
      SmsThemeConfiguration(
        defaultStyle: defaultStyle ?? this.defaultStyle,
        errorStyle: errorStyle ?? this.errorStyle,
        successStyle: successStyle ?? this.successStyle,
        disabledStyle: disabledStyle ?? this.disabledStyle,
        focusedStyle: focusedStyle ?? this.focusedStyle,
        submittedStyle: submittedStyle ?? this.submittedStyle,
        unfilledStyle: unfilledStyle ?? this.unfilledStyle,
      );
}

/// Single sms field theme configuration class
class SmsFieldTheme {
  const SmsFieldTheme({
    this.width,
    this.height,
    this.textStyle,
    this.margin,
    this.padding,
    this.constraints,
    this.decoration,
  });

  /// Width of each pin code field
  final double? width;

  /// Height of each pin code field
  final double? height;

  /// The text style to use for pin field
  final TextStyle? textStyle;

  /// Empty space to surround the pin code field container.
  final EdgeInsetsGeometry? margin;

  /// Empty space to inscribe the pin code field container.
  final EdgeInsetsGeometry? padding;

  /// Additional constraints to apply to the each field container.
  final BoxConstraints? constraints;

  /// The decoration of an individual pin code field
  final BoxDecoration? decoration;

  SmsFieldTheme copyWith({
    double? width,
    double? height,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxDecoration? decoration,
    BoxConstraints? constraints,
  }) =>
      SmsFieldTheme(
        width: width ?? this.width,
        height: height ?? this.height,
        textStyle: textStyle ?? this.textStyle,
        padding: padding ?? this.padding,
        margin: margin ?? this.margin,
        decoration: decoration ?? this.decoration,
        constraints: constraints ?? this.constraints,
      );

  SmsFieldTheme copyDecorationWith({
    Color? color,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape? shape,
  }) {
    assert(decoration != null);
    return copyWith(
      decoration: decoration?.copyWith(
        color: color,
        image: image,
        border: border,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        gradient: gradient,
        backgroundBlendMode: backgroundBlendMode,
        shape: shape,
      ),
    );
  }

  SmsFieldTheme copyBorderWith({required Border border}) {
    assert(decoration != null);
    return copyWith(
      decoration: decoration?.copyWith(border: border),
    );
  }
}
