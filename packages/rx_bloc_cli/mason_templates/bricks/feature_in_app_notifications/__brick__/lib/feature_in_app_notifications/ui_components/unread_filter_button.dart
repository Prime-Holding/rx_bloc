{{> licence.dart }}

import 'package:flutter/material.dart';

import '../../app_extensions.dart';

class UnreadFilterButton extends StatelessWidget {
  const UnreadFilterButton({
    required this.unreadCount,
    required this.isActive,
    required this.onPressed,
    super.key,
  });

  final int unreadCount;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.designSystem.colors;
    final spacing = context.designSystem.spacing;

    if (unreadCount == 0 && !isActive) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: spacing.m,
          vertical: spacing.xs,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? colors.colorScheme.primary
              : colors.colorScheme.surface,
          borderRadius: BorderRadius.circular(spacing.l),
          border: Border.all(
            color: isActive
                ? colors.colorScheme.primary
                : colors.colorScheme.outlineVariant,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mark_unread_chat_alt_outlined,
              size: spacing.m,
              color: isActive
                  ? colors.colorScheme.onPrimary
                  : colors.colorScheme.primary,
            ),
            SizedBox(width: spacing.xs),
            Text(
              '${context.l10n.inAppNotificationsUnread} ($unreadCount)',
              style: (context.designSystem.typography.textTheme.labelLarge ??
                      context.designSystem.typography.textTheme.bodyMedium)
                  ?.copyWith(
                color: isActive
                    ? colors.colorScheme.onPrimary
                    : colors.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
