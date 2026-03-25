{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app_extensions.dart';

class IaNotification extends StatelessWidget {
  const IaNotification({
    required this.title,
    required this.description,
    required this.date,
    this.isUnread = false,
    this.isFirstInGroup = false,
    this.isLastInGroup = false,
    this.onTap,
    super.key,
  });

  /// The title of the notification.
  final String title;

  /// The description of the notification.
  final String description;

  /// The date of the notification.
  final DateTime date;

  /// Whether the notification is unread.
  final bool isUnread;

  /// Whether this is the first card in the group (round top corners).
  final bool isFirstInGroup;

  /// Whether this is the last card in the group (round bottom corners).
  final bool isLastInGroup;

  /// The callback to be called when the notification is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final designSystem = context.designSystem;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(
          designSystem.spacing.s,
          designSystem.spacing.s,
          designSystem.spacing.m,
          designSystem.spacing.s,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: isFirstInGroup
                ? Radius.circular(designSystem.spacing.l)
                : Radius.zero,
            topRight: isFirstInGroup
                ? Radius.circular(designSystem.spacing.l)
                : Radius.zero,
            bottomLeft: isLastInGroup
                ? Radius.circular(designSystem.spacing.l)
                : Radius.zero,
            bottomRight: isLastInGroup
                ? Radius.circular(designSystem.spacing.l)
                : Radius.zero,
          ),
          color: isUnread
              ? designSystem.colors.colorScheme.primaryContainer
              : designSystem.colors.colorScheme.surface,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: designSystem.spacing.s,
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        (designSystem.typography.textTheme.titleMedium ??
                                designSystem.typography.textTheme.bodyLarge)
                            ?.copyWith(
                              color: isUnread
                                  ? designSystem
                                        .colors
                                        .colorScheme
                                        .onPrimaryContainer
                                  : designSystem.colors.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                  ),
                ),
                SizedBox(height: designSystem.spacing.xxxs),
                Text(
                  description,
                  textAlign: TextAlign.start,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style:
                      (designSystem.typography.textTheme.bodyMedium ??
                              designSystem.typography.textTheme.bodyLarge)
                          ?.copyWith(
                            color: isUnread
                                ? designSystem
                                      .colors
                                      .colorScheme
                                      .onPrimaryContainer
                                : designSystem
                                      .colors
                                      .colorScheme
                                      .onSurfaceVariant,
                          ),
                ),
                SizedBox(height: designSystem.spacing.xss),
                Text(
                  DateFormat('dd.MM.yyyy').format(date),
                  textAlign: TextAlign.start,
                  style:
                      (designSystem.typography.textTheme.labelSmall ??
                              designSystem.typography.textTheme.bodySmall)
                          ?.copyWith(
                            color: isUnread
                                ? designSystem
                                      .colors
                                      .colorScheme
                                      .onPrimaryContainer
                                : designSystem
                                      .colors
                                      .colorScheme
                                      .onSurfaceVariant,
                          ),
                ),
              ],
            ),
            if (isUnread)
              PositionedDirectional(
                top: designSystem.spacing.xss,
                end: designSystem.spacing.xss,
                child: Container(
                  width: designSystem.spacing.xss1,
                  height: designSystem.spacing.xss1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: designSystem.colors.colorScheme.error,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
