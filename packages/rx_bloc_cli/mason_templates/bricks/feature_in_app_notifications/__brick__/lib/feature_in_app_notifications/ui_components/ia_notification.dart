import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app_extensions.dart';

class IaNotification extends StatelessWidget {
  const IaNotification({
    required this.title,
    required this.description,
    required this.date,
    this.isUnread = false,
    this.onTap,
    super.key,
  });

  final String title;
  final String description;
  final DateTime date;
  final bool isUnread;
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
        color: isUnread
            ? designSystem.colors.unreadNotificationColor
            : designSystem.colors.readNotificationColor,
        borderRadius: BorderRadius.circular(designSystem.spacing.m),
        boxShadow: [
          BoxShadow(
            color: designSystem.colors.tintColor.withValues(alpha: 0.1),
            blurRadius: designSystem.spacing.m,
            offset: Offset(0, designSystem.spacing.xs),
          ),
        ],
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
                    height: 1.6,
                  ),
                ),
              ),
              SizedBox(height: designSystem.spacing.xxxs),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: designSystem.typography.h1Reg12.copyWith(
                  color: designSystem.colors.messageColor,
                  height: 1.8,
                ),
              ),
              SizedBox(height: designSystem.spacing.xss),
              Text(
                DateFormat('dd.MM.yyyy').format(date),
                style: designSystem.typography.h3Med11.copyWith(
                  color: designSystem.colors.tintColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  height: 2.2,
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
                width: designSystem.spacing.xs,
                height: designSystem.spacing.xs,
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
