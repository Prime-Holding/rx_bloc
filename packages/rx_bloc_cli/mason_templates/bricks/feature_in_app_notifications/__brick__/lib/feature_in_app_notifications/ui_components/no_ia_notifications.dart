{{> licence.dart }}

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
        color: context.designSystem.colors.colorScheme.primary,
        size: context.designSystem.spacing.xl,
      ),
      SizedBox(height: context.designSystem.spacing.xs),
      Text(
        context.l10n.inAppNotificationsEmptyStateTitle,
        textAlign: TextAlign.center,
        style: (context.designSystem.typography.textTheme.titleMedium ??
                context.designSystem.typography.textTheme.bodyLarge)
            ?.copyWith(
          color: context.designSystem.colors.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}
