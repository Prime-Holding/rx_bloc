{{> licence.dart }}

import 'package:collection/collection.dart';
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
    body:
        RxPaginatedBuilder<
          InAppNotificationsBlocType,
          InAppNotificationModel
        >.withRefreshIndicator(
          state: (bloc) => bloc.states.notifications,
          onBottomScrolled: (bloc) => bloc.events.loadNotifications(),
          onRefresh: (bloc) async {
            bloc.events.loadNotifications(reset: true);
            return bloc.states.notifications.waitToLoad();
          },
          buildLoading: (context, list, bloc) => _buildScrollViewWithAppBar(
            context,
            bodySlivers: [
              SliverFillRemaining(
                child: Center(child: AppLoadingIndicator.taskValue(context)),
              ),
            ],
          ),
          buildError: (context, list, bloc) => _buildScrollViewWithAppBar(
            context,
            bodySlivers: [
              SliverFillRemaining(
                child: AppErrorWidget(
                  error: list.error!,
                  onTabRetry: () => bloc.events.loadNotifications(reset: true),
                ),
              ),
            ],
          ),
          buildSuccess: (context, list, bloc) {
            if (list.isEmpty) {
              return _buildScrollViewWithAppBar(
                context,
                bodySlivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.designSystem.spacing.m,
                      vertical: context.designSystem.spacing.s,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(height: context.designSystem.spacing.m),
                          const NoIaNotifications(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            final groups = _groupNotificationsByMonth(list);
            final loadedCount = groups.fold<int>(0, (sum, g) => sum + g.length);
            final hasMore = loadedCount < list.itemCount;

            return _buildScrollViewWithAppBar(
              context,
              bodySlivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.designSystem.spacing.m,
                    vertical: context.designSystem.spacing.s,
                  ),
                  sliver: SliverList.separated(
                    itemCount: groups.length + (hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= groups.length) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(
                              context.designSystem.spacing.m,
                            ),
                            child: AppLoadingIndicator.textButtonValue(context),
                          ),
                        );
                      }
                      return _buildMonthGroup(context, groups[index]);
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: context.designSystem.spacing.m),
                  ),
                ),
              ],
            );
          },
        ),
  );

  Widget _buildScrollViewWithAppBar(
    BuildContext context, {
    required List<Widget> bodySlivers,
  }) => CustomScrollView(
    slivers: [
      SliverAppBar.large(
        title: Text(context.l10n.notifications),
        backgroundColor: context.designSystem.colors.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        forceMaterialTransparency: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(context.designSystem.spacing.xxxxl2),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.designSystem.spacing.m,
              vertical: context.designSystem.spacing.xs,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildFilterBar(context),
            ),
          ),
        ),
      ),
      ...bodySlivers,
    ],
  );

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
            style: designSystem.typography.textTheme.titleMedium?.copyWith(
              color: designSystem.colors.colorScheme.onSurface,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(designSystem.spacing.xss),
          decoration: BoxDecoration(
            color: designSystem.colors.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(designSystem.spacing.l),
            boxShadow: [
              BoxShadow(
                color: designSystem.colors.colorScheme.surfaceTint.withValues(
                  alpha: 0.1,
                ),
                blurRadius: designSystem.spacing.xxl,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: notifications
                .mapIndexed(
                  (i, notification) => IaNotification(
                    title: notification.title,
                    description: notification.description,
                    date: notification.date,
                    isUnread: notification.isUnread,
                    isFirstInGroup: i == 0,
                    isLastInGroup: i == notifications.length - 1,
                    onTap: () {
                      if (notification.isUnread) {
                        context
                            .read<InAppNotificationsBlocType>()
                            .events
                            .markAsRead(notification.id);
                      }
                      GoRouter.of(context).push(
                        InAppNotificationDetailsRoute(
                          notification.id,
                        ).routeLocation,
                      );
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
