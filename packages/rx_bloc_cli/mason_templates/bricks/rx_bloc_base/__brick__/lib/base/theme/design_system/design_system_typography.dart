{{> licence.dart }}

import 'package:flutter/material.dart';

import 'design_system_colors.dart';

class DesignSystemTypography {
  DesignSystemTypography.withColor(DesignSystemColors designSystemColor)
      : _designSystemColor = designSystemColor;

  final DesignSystemColors _designSystemColor;

  // Material design typography:
  // https://material.io/design/typography/the-type-system.html#type-scale

  // Keep the general purpose styles declared as 'const'. If not possible then
  // declare them as late final properties.

  final bold30 = const TextStyle(
      fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, fontSize: 30.0);

  final h1Med26 = const TextStyle(
      fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, fontSize: 26.0);

  final h1Bold24 = const TextStyle(
      fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, fontSize: 24.0);

  final h1Bold20 = const TextStyle(
      fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, fontSize: 20.0);

  final h1Reg20 = const TextStyle(
      fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 20.0);

final h1Reg22 = const TextStyle(
fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 20.0);

  final h1bold24 = const TextStyle(
      fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, fontSize: 24.0);

  final h1Bold18 = const TextStyle(
      fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, fontSize: 18.0);

  final h2ExtraBold18 = const TextStyle(
      fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, fontSize: 18.0);

  final h2Med18 = const TextStyle(
      fontWeight: FontWeight.w500, fontStyle: FontStyle.normal, fontSize: 18.0);

  final h1Bold16 = const TextStyle(
      fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, fontSize: 16.0);

  final h2Med18Italic = const TextStyle(
      fontWeight: FontWeight.w500, fontStyle: FontStyle.italic, fontSize: 18.0);

  final h2Med16 = const TextStyle(
      fontWeight: FontWeight.w500, fontStyle: FontStyle.normal, fontSize: 16.0);

  final h2Semibold17 = const TextStyle(
      fontWeight: FontWeight.w600, fontStyle: FontStyle.normal, fontSize: 17.0);

  final h2Semibold16 = const TextStyle(
      fontWeight: FontWeight.w600, fontStyle: FontStyle.normal, fontSize: 16.0);

  final h2Reg16 = const TextStyle(
      fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0);

  final h3Med13 = const TextStyle(
      fontWeight: FontWeight.w500, fontStyle: FontStyle.normal, fontSize: 13.0);

  final h3Med14 = const TextStyle(
      fontWeight: FontWeight.w500, fontStyle: FontStyle.normal, fontSize: 14.0);

  final h3Reg14 = const TextStyle(
      fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 14.0);

  final h3Reg13 = const TextStyle(
      fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 13.0);

  final h1Reg12 = const TextStyle(
      fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 12.0);

  final h3Med11 = const TextStyle(
      fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 11.0);

  /// App specific typography
{{#enable_feature_counter}}
  late final counterTitle =
      h1Reg12.copyWith(color: _designSystemColor.primaryColor);

  late final counterText = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 96,
    color: _designSystemColor.gray..withValues(alpha: (0.8 * 255).roundToDouble()),
    letterSpacing: -1.5,
  );
{{/enable_feature_counter}}
  late final fadedButtonText =
      h3Med14.copyWith(color: _designSystemColor.black);
  {{#enable_social_logins}}
  late final socialButtonText = TextStyle(
      fontSize: 14,
      color: _designSystemColor.socialButtonText,
  );
  {{/enable_social_logins}}
  {{#enable_feature_otp}}
  late final otpPinText = const TextStyle(
    fontSize: 18,
    color: Colors.black87,
  );

  late final otpResendButtonText = const TextStyle(
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.8,
    fontSize: 10.0)
      .copyWith(color: _designSystemColor.black);
  {{/enable_feature_otp}}{{#enable_feature_onboarding}}

  late final onboardingTitle = h1Reg22.copyWith(
    fontSize: 32,
    color: _designSystemColor.primaryColor,
  );{{/enable_feature_onboarding}}
}
