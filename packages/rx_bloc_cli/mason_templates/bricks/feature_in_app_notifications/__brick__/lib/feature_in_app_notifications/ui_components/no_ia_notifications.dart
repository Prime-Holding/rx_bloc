import 'package:flutter/material.dart';

import '../../app_extensions.dart';

class NoIaNotifications extends StatelessWidget {
  const NoIaNotifications({super.key});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        context.designSystem.icons.notifications.icon,
        color: context.designSystem.colors.inactiveButtonTextColor,
        size: context.designSystem.spacing.xl,
      ),
      SizedBox(height: context.designSystem.spacing.xs),
      Text(
        context.l10n.inAppNotificationsEmptyStateTitle,
        textAlign: TextAlign.center,
        style: context.designSystem.typography.h3Med11.copyWith(
          color: context.designSystem.colors.inactiveButtonTextColor,
          fontWeight: FontWeight.w700,
          fontSize: 10,
          height: 2.2,
          letterSpacing: 0.8,
        ),
      ),
    ],
  );
}
