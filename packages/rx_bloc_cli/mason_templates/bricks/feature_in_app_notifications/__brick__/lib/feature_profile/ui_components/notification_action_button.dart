import 'package:flutter/material.dart';

import '../../app_extensions.dart';

class NotificationActionButton extends StatelessWidget {
  const NotificationActionButton({
    required this.notificationCount,
    required this.onPressed,
    super.key,
  });

  final int notificationCount;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final count = notificationCount < 0 ? 0 : notificationCount;
    return IconButton(
      onPressed: onPressed,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          context.designSystem.icons.notificationsActive,
          if (count>0)
          Positioned(
            top: -6,
            right: -7,
            child: _NotificationCountBadge(count:count),
          ),
        ],
      ),
    );
  }
}

class _NotificationCountBadge extends StatelessWidget {
  const _NotificationCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
    padding: const EdgeInsets.symmetric(horizontal: 4),
    decoration: BoxDecoration(
      color: context.designSystem.colors.errorColor,
      borderRadius: BorderRadius.circular(10),
    ),
    alignment: Alignment.center,
    child: Text(
      '$count',
      style: context.designSystem.typography.h1Reg12.copyWith(
        color: Colors.white,
      ),
    ),
  );
}
