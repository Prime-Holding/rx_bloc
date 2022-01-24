import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';
import 'package:reminders/feature_dashboard/models/dashboard_model.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_reminder_tile.dart';
import '../../base/common_ui_components/app_sticky_header.dart';
import '../../base/models/reminder_model.dart';
import '../blocs/dashboard_bloc.dart';
import '../di/dashboard_dependencies.dart';

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
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(context),
        backgroundColor: context.designSystem.colors.backgroundListColor,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildErrorListener(),
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
                              color: context.designSystem.colors.secondaryColor,
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
                    const CircularProgressIndicator(),
                buildError: (context, error, bloc) => Text(error.toString()),
              ),
            ),
          ],
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
              child: DashboardStatItem(count: incompleteCount),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DashboardStatItem(count: completeCount),
            ),
          ],
        ),
      );
}

class DashboardStatItem extends StatelessWidget {
  const DashboardStatItem({
    required this.count,
    Key? key,
  }) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) => Container(
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
      );
}
