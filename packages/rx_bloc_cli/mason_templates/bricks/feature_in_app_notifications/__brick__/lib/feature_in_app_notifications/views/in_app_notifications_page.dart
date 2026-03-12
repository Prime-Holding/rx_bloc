{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_widget.dart';
import '../../base/common_ui_components/app_loading_indicator.dart';
import '../../lib_router/router.dart';
import '../blocs/in_app_notifications_bloc.dart';
import '../models/in_app_notification_model.dart';
import '../ui_components/ia_notification.dart';
import '../ui_components/no_ia_notifications.dart';
import '../ui_components/unread_filter_button.dart';

class InAppNotificationsPage extends StatelessWidget {
  const InAppNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.designSystem.colors.colorScheme.surface,
        body: RxPaginatedBuilder<
          InAppNotificationsBlocType,
          InAppNotificationModel
        >.withRefreshIndicator(
          state: (bloc) => bloc.states.notifications,
          onBottomScrolled: (bloc) => bloc.events.loadNotifications(),
          onRefresh: (bloc) async {
            bloc.events.loadNotifications(reset: true);
            return bloc.states.notifications.waitToLoad();
          },
          buildLoading: (context, list, bloc) =>
              _buildScrollView(context, slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: AppLoadingIndicator.taskValue(context),
              ),
            ),
          ]),
          buildError: (context, list, bloc) => _buildScrollView(context, slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: AppErrorWidget(
                  error: list.error!,
                  onTabRetry: () => bloc.events.loadNotifications(reset: true),
                ),
              ),
            ),
          ]),
          buildSuccess: (context, list, bloc) {
            final padding = EdgeInsets.symmetric(
              horizontal: context.designSystem.spacing.m,
              vertical: context.designSystem.spacing.s,
            );

            if (list.isEmpty) {
              return _buildScrollView(context, slivers: [
                SliverPadding(
                  padding: padding,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildFilterBar(context),
                      SizedBox(height: context.designSystem.spacing.m),
                      const NoIaNotifications(),
                    ]),
                  ),
                ),
              ]);
            }

            final groups = _groupNotificationsByMonth(list);
            final loadedCount = groups.fold<int>(0, (sum, g) => sum + g.length);
            final hasMore = loadedCount < list.itemCount;
            final itemCount = 1 + groups.length + (hasMore ? 1 : 0);
            final spacing = context.designSystem.spacing.m;

            return _buildScrollView(context, slivers: [
              SliverPadding(
                padding: padding,
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index.isOdd) {
                        return SizedBox(height: spacing);
                      }
                      final itemIndex = index ~/ 2;
                      if (itemIndex == 0) {
                        return _buildFilterBar(context);
                      }
                      if (itemIndex > groups.length) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(
                              context.designSystem.spacing.m,
                            ),
                            child: AppLoadingIndicator.textButtonValue(context),
                          ),
                        );
                      }
                      return _buildMonthGroup(context, groups[itemIndex - 1]);
                    },
                    childCount: itemCount > 0 ? 2 * itemCount - 1 : 0,
                    findChildIndexCallback: null,
                  ),
                ),
              ),
            ]);
          },
        ),
      );

  CustomScrollView _buildScrollView(
    BuildContext context, {
    required List<Widget> slivers,
  }) {
    final colors = context.designSystem.colors.colorScheme;
    final typography = context.designSystem.typography.textTheme;
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: Text(context.l10n.notifications),
          backgroundColor: colors.surface,
          foregroundColor: colors.onSurface,
          surfaceTintColor: colors.surfaceTint,
          titleTextStyle: typography.headlineLarge
              ?.copyWith(color: colors.onSurface),
        ),
        ...slivers,
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context) => Row(
    children: [
      RxBlocBuilder<InAppNotificationsBlocType, int>(
        state: (bloc) => bloc.states.unreadCount,
        builder: (context, unreadSnapshot, bloc) =>
            RxBlocBuilder<InAppNotificationsBlocType, bool>(
              state: (bloc) => bloc.states.isFilteredByUnread,
              builder: (context, filterSnapshot, bloc) => UnreadFilterButton(
                unreadCount: unreadSnapshot.data ?? 0,
                isActive: filterSnapshot.data ?? false,
                onPressed: () => bloc.events.toggleUnreadFilter(),
              ),
            ),
      ),
    ],
  );

  List<List<InAppNotificationModel>> _groupNotificationsByMonth(
    PaginatedList<InAppNotificationModel> list,
  ) => Iterable.generate(list.itemCount, list.getItem)
      .takeWhile((item) => item != null)
      .cast<InAppNotificationModel>()
      .fold<List<List<InAppNotificationModel>>>([], (groups, item) {
        if (groups.isEmpty ||
            groups.last.first.date.year != item.date.year ||
            groups.last.first.date.month != item.date.month) {
          groups.add([item]);
        } else {
          groups.last.add(item);
        }
        return groups;
      });

  Widget _buildMonthGroup(
    BuildContext context,
    List<InAppNotificationModel> notifications,
  ) {
    final designSystem = context.designSystem;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: designSystem.spacing.xs,
            bottom: designSystem.spacing.s,
          ),
          child: Text(
            DateFormat.yMMMM().format(notifications.first.date),
            style: (designSystem.typography.textTheme.titleMedium ??
                    designSystem.typography.textTheme.bodyLarge)
                ?.copyWith(
              color: designSystem.colors.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(designSystem.spacing.xsss),
          decoration: BoxDecoration(
            color: designSystem.colors.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(designSystem.spacing.xl),
            boxShadow: [
              BoxShadow(
                color: designSystem.colors.colorScheme.primary.withValues(alpha: 0.08),
                blurRadius: designSystem.spacing.l,
              ),
            ],
          ),
          child: Column(
            children: [
              for (var i = 0; i < notifications.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: designSystem.colors.colorScheme.outlineVariant,
                    indent: designSystem.spacing.s,
                    endIndent: designSystem.spacing.s,
                  ),
                IaNotification(
                  title: notifications[i].title,
                  description: notifications[i].description,
                  date: notifications[i].date,
                  isUnread: notifications[i].isUnread,
                  isFirstInGroup: i == 0,
                  isLastInGroup: i == notifications.length - 1,
                  onTap: () {
                    if (notifications[i].isUnread) {
                      context
                          .read<InAppNotificationsBlocType>()
                          .events
                          .markAsRead(notifications[i].id);
                    }
                    GoRouter.of(context).push(
                      InAppNotificationDetailsRoute(
                        notifications[i].id,
                      ).routeLocation,
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
