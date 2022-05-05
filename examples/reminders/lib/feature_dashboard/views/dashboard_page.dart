import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_progress_indicator.dart';
import '../../base/common_ui_components/app_reminder_tile.dart';
import '../../base/common_ui_components/app_sticky_header.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../../feature_reminder_manage/blocs/reminder_manage_bloc.dart';
import '../blocs/dashboard_bloc.dart';
import '../di/dashboard_dependencies.dart';
import '../models/dashboard_model.dart';

class DashboardPage extends StatelessWidget implements AutoRouteWrapper {
  const DashboardPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => MultiProvider(
        providers: DashboardDependencies.of(context).providers,
        child: this,
      );

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: Scaffold(
          appBar: _buildAppBar(context),
          backgroundColor: context.designSystem.colors.backgroundListColor,
          body: RefreshIndicator(
            onRefresh: () async =>
                context.read<DashboardBlocType>().events.fetchData(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildErrorListener(),
                _buildOnDeletedListener(),
                _buildOnCreatedListener(),
                Expanded(
                  child: RxResultBuilder<DashboardBlocType, DashboardModel>(
                    state: (bloc) => bloc.states.data,
                    buildSuccess: (context, data, bloc) => CustomScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      slivers: [
                        SliverToBoxAdapter(
                          child: DashboardStats(
                            completeCount: data.completeCount,
                            incompleteCount: data.incompleteCount,
                          ),
                        ),
                        SliverStickyHeader(
                          header: const Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: AppStickyHeader(
                              text: 'Overdue',
                            ),
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) => Container(
                                decoration: BoxDecoration(
                                  color: context
                                      .designSystem.colors.secondaryColor,
                                  borderRadius:
                                      _getRadius(i, data.reminderList.length),
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: AppReminderTile(
                                  reminder: data.reminderList[i],
                                  isFirst: i == 0,
                                  isLast: i == data.reminderList.length - 1,
                                ),
                              ),
                              childCount: data.reminderList.length,
                            ),
                          ),
                        )
                      ],
                    ),
                    buildLoading: (context, bloc) =>
                        const AppProgressIndicator(),
                    buildError: (context, error, bloc) =>
                        Text(error.toString()),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  AppBar _buildAppBar(BuildContext context) => AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: context.read<DashboardBlocType>().events.fetchData,
          ),
        ],
      );

  Widget _buildOnDeletedListener() =>
      RxBlocListener<ReminderManageBlocType, Result<ReminderModel>>(
        state: (bloc) => bloc.states.onDeleted,
        listener: (context, onDeleted) {
          if (onDeleted is ResultSuccess && onDeleted != null) {
            final _reminderTitleName =
                (onDeleted as ResultSuccess<ReminderModel>).data.title;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.reminderDeleted(_reminderTitleName)),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      );

  Widget _buildOnCreatedListener() =>
      RxBlocListener<ReminderManageBlocType, Result<ReminderModel>>(
        state: (bloc) => bloc.states.onCreated,
        listener: (context, onCreated) {
          if (onCreated is ResultSuccess && onCreated != null) {
            final _reminderTitleName =
                (onCreated as ResultSuccess<ReminderModel>).data.title;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.reminderCreated(_reminderTitleName)),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      );

  Widget _buildErrorListener() => RxBlocListener<DashboardBlocType, String>(
        state: (bloc) => bloc.states.errors,
        listener: (context, errorMessage) =>
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage ?? ''),
            behavior: SnackBarBehavior.floating,
          ),
        ),
      );

  BorderRadiusGeometry? _getRadius(int i, int length) {
    if (i == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      );
    }

    if (i == length - 1) {
      return const BorderRadius.only(
        bottomRight: Radius.circular(20),
        bottomLeft: Radius.circular(20),
      );
    }

    return null;
  }
}

class DashboardStats extends StatelessWidget {
  const DashboardStats({
    required this.incompleteCount,
    required this.completeCount,
    Key? key,
  }) : super(key: key);

  final int incompleteCount;
  final int completeCount;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        child: Row(
          children: [
            Expanded(
              child: DashboardStatItem(
                count: incompleteCount,
                label: context.l10n.incomplete,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DashboardStatItem(
                count: completeCount,
                label: context.l10n.complete,
              ),
            ),
          ],
        ),
      );
}

class DashboardStatItem extends StatelessWidget {
  const DashboardStatItem({
    required this.count,
    required this.label,
    Key? key,
  }) : super(key: key);

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SizedBox(
            height: 30,
            child: Text(
              label,
              style: context.designSystem.typography.alertSecondaryTitle,
            ),
          ),
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: context.designSystem.colors.secondaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: context.designSystem.colors.primaryVariant,
                  ),
                  Expanded(
                    child: Text(
                      count.toString(),
                      textAlign: TextAlign.center,
                      style: context.designSystem.typography.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
