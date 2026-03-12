{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../app_extensions.dart';
import '../../lib_router/router.dart';
import '../blocs/unread_notifications_bloc.dart';

class NotificationActionButton extends StatelessWidget {
  const NotificationActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RxBlocBuilder<UnreadNotificationsBlocType, int>(
      state: (bloc) => bloc.states.inAppNotificationCount,
      builder: (context, notificationCountSnapshot, bloc) {
        int count = notificationCountSnapshot.data ?? 0;
        count = count < 0 ? 0 : count;
        return IconButton(
          onPressed: () async {
            await GoRouter.of(
              context,
            ).push(const InAppNotificationsRoute().location);
            bloc.events.fetchUnreadNotifications();
          },
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              context.designSystem.icons.notificationsActive,
              if (count > 0)
                Positioned(
                  top: -6,
                  right: -7,
                  child: _NotificationCountBadge(count: count),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _NotificationCountBadge extends StatelessWidget {
  const _NotificationCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final spacing = context.designSystem.spacing;
    return Container(
      constraints: BoxConstraints(minWidth: spacing.m, minHeight: spacing.m),
      padding: EdgeInsets.symmetric(horizontal: spacing.xss),
      decoration: BoxDecoration(
        color: context.designSystem.colors.colorScheme.error,
        borderRadius: BorderRadius.circular(spacing.xs1),
      ),
      alignment: Alignment.center,
      child: Text(
        count.toString(),
        style: (context.designSystem.typography.textTheme.labelSmall ??
                context.designSystem.typography.textTheme.bodySmall)
            ?.copyWith(
          color: context.designSystem.colors.colorScheme.onError,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
