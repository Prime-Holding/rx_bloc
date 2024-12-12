{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';
import '../../base/common_services/users_service.dart';

void showMockDeepLinkSheet(
  BuildContext context, {
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
            text: mockEmailDeepLinkSuccess,
            onPressed: onDeepLinkSuccessTapped,
          ),
          SizedBox(height: context.designSystem.spacing.xl),
          Text(context.l10n.featureOnboarding.titleMockDeepLinkError),
          SizedBox(height: context.designSystem.spacing.m),
          GradientFillButton(
            text: mockEmailDeepLinkError,
            onPressed: onDeepLinkErrorTapped,
            colorStyle: ButtonColorStyle.fromContext(
              context,
              activeGradientColorStart: context.designSystem.colors.errorColor,
              activeGradientColorEnd: context.designSystem.colors.black,
              activeButtonTextColor: context.designSystem.colors.white,
            ),
          ),
        ],
      ),
    );
