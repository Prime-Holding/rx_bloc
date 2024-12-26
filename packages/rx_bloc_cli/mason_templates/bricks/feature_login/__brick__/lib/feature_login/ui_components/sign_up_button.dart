{{> licence.dart }}

import 'package:flutter/material.dart';

import '../../app_extensions.dart';

/// Sign up button used to initiate the registration process
class SignUpButton extends StatelessWidget {
  const SignUpButton({
    required this.isLoading,
    this.onPressed,
    super.key,
  });

  /// Flag indicating if the button is in loading state
  final bool isLoading;

  /// Callback when the button is pressed
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          child: Padding(
            padding: EdgeInsets.all(context.designSystem.spacing.m),
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: context.l10n.featureLogin.dontHaveAccount,
                style: context.designSystem.typography.h2Reg16
                    .copyWith(color: context.designSystem.colors.dividerColor),
                children: [
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: context.l10n.featureLogin.signUpLabel,
                    style: context.designSystem.typography.h1Bold16,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
