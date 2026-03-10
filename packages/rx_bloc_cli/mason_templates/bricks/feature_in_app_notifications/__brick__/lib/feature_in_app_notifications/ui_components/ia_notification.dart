import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app_extensions.dart';

class IaNotification extends StatelessWidget {
  const IaNotification({
    required this.title,
    required this.description,
    required this.date,
    this.isUnread = false,
    this.previousUnread = false,
    this.nextUnread = false,
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

  /// Whether the previous notification is unread.
  final bool previousUnread;

  /// Whether the next notification is unread.
  final bool nextUnread;

  /// The callback to be called when the notification is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final designSystem = context.designSystem;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          designSystem.spacing.s,
          designSystem.spacing.s,
          designSystem.spacing.m,
          designSystem.spacing.xs,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: previousUnread
                ? Radius.zero
                : Radius.circular(designSystem.spacing.l),
            topRight: previousUnread
                ? Radius.zero
                : Radius.circular(designSystem.spacing.l),
            bottomLeft: nextUnread
                ? Radius.zero
                : Radius.circular(designSystem.spacing.l),
            bottomRight: nextUnread
                ? Radius.zero
                : Radius.circular(designSystem.spacing.l),
          ),
          color: isUnread
              ? designSystem.colors.unreadNotificationColor
              : designSystem.colors.readNotificationColor,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: designSystem.spacing.s),
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: designSystem.typography.h3Med14.copyWith(
                      color: designSystem.colors.messageColor,
                      fontWeight: FontWeight.bold,
                      fontSize: context.designSystem.spacing.m,
                      height: 1.6,
                    ),
                  ),
                ),
                SizedBox(height: designSystem.spacing.xxxs),
                Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: designSystem.typography.h2Reg16.copyWith(
                    color: designSystem.colors.messageColor,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: designSystem.spacing.xss),
                Text(
                  DateFormat('dd.MM.yyyy').format(date),
                  style: designSystem.typography.h3Med11.copyWith(
                    color: designSystem.colors.tintColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    height: 2,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
            if (isUnread)
              Positioned(
                top: designSystem.spacing.xss,
                right: designSystem.spacing.xss,
                child: Container(
                  width: designSystem.spacing.xss1,
                  height: designSystem.spacing.xss1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: designSystem.colors.errorColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
