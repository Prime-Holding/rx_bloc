{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';
import '../common_services/onboarding_service.dart';

/// Shows a selection of fake deep links for email confirmation.
/// Used for demo purposes, should be removed in a real app
void showMockDeepLinkSheet(
  BuildContext context, {
  String deepLinkSuccess = mockEmailDeepLinkSuccess,
  String deepLinkError = mockEmailDeepLinkError,
  required Function() onDeepLinkSuccessTapped,
  required Function() onDeepLinkErrorTapped,
}) =>
    showBlurredBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.l10n.featureOnboarding.titleMockDeepLinkSuccess),
          SizedBox(height: context.designSystem.spacing.m),
          GradientFillButton(
            text: deepLinkSuccess,
            onPressed: onDeepLinkSuccessTapped,
          ),
          SizedBox(height: context.designSystem.spacing.xl),
          Text(context.l10n.featureOnboarding.titleMockDeepLinkError),
          SizedBox(height: context.designSystem.spacing.m),
          GradientFillButton(
            text: deepLinkError,
            onPressed: onDeepLinkErrorTapped,
            colorStyle: ButtonColorStyle.fromContext(
              context,
              activeGradientColorStart: context.designSystem.colors.errorColor,
              activeGradientColorEnd: context.designSystem.colors.messageColor,
              activeButtonTextColor:
                  context.designSystem.colors.activeButtonTextColor,
            ),
          ),
        ],
      ),
    );
