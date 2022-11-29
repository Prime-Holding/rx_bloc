import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../../app_extensions.dart';
import '../../base/common_blocs/firebase_bloc.dart';
import '../../base/common_ui_components/app_progress_indicator.dart';
import '../../base/common_ui_components/app_sticky_header.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../../feature_reminder_manage/blocs/reminder_manage_bloc.dart';
import '../blocs/dashboard_bloc.dart';
import '../di/dashboard_dependencies.dart';
import '../models/dashboard_model.dart';
import 'dashboard_paginated_list.dart';

class DashboardPage extends StatelessWidget implements AutoRouteWrapper {
  DashboardPage({
    super.key,
  });

  final _scrollController = ScrollController();

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
          body: Column(
            children: [
              _buildLogoutListener(),
              Expanded(child: _buildBodyNew(context)),
            ],
          ),
        ),
      );

  Widget _buildLogoutListener() => RxBlocListener<FirebaseBlocType, bool>(
        state: (bloc) => bloc.states.userLoggedOut,
        listener: (context, currentUser) {
          if (currentUser == true) {
            context.router.popUntilRouteWithName(FacebookLoginRoute.name);
            context.router.replace(const FacebookLoginRoute());
          }
        },
      );

  Widget _buildBodyNew(BuildContext context) =>
      RxResultBuilder<DashboardBlocType, DashboardCountersModel>(
        state: (bloc) => bloc.states.dashboardCounters,
        buildSuccess: (context, data, bloc) => NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
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
                        text: 'Incomplete overdue',
                      ),
                    ),
                  )
                ],
            body: _buildDashboardCounters(context)),
        buildLoading: (context, bloc) => const AppProgressIndicator(),
        buildError: (context, error, bloc) => Text(error.toString()),
        // )
      );

  Widget _buildDashboardCounters(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildErrorListener(),
          _buildOnDeletedListener(),
          _buildOnCreatedListener(),
          const Expanded(child: DashboardPaginatedList()),
        ],
      );

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {
            context.read<FirebaseBlocType>().events.logOut();
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  Widget _buildOnDeletedListener() =>
      RxBlocListener<ReminderManageBlocType, Result<ReminderModel>>(
        state: (bloc) => bloc.states.onDeleted,
        listener: (context, onDeleted) {
          if (onDeleted is ResultSuccess) {
            final reminderTitleName =
                (onDeleted as ResultSuccess<ReminderModel>).data.title;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.reminderDeleted(reminderTitleName)),
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
          if (onCreated is ResultSuccess) {
            final reminderTitleName =
                (onCreated as ResultSuccess<ReminderModel>).data.title;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.reminderCreated(reminderTitleName)),
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
            content: Text(errorMessage),
            behavior: SnackBarBehavior.floating,
          ),
        ),
      );
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
