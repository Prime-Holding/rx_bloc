import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../../lib_todo_actions/ui_components/app_todo_list_bulk_edit_popup_menu_button.dart';
import '../blocs/statistics_bloc.dart';
import '../models/todo_stats_model.dart';
import '../ui_components/statistics_list_widget.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.todos),
          actions: [
            AppTodoListBulkEditPopupMenuButton(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'fab',
          onPressed: () =>
              context.read<RouterBlocType>().events.push(TodoCreateRoute()),
          shape: const OvalBorder(),
          child: context.designSystem.icons.add,
        ),
        body: RxBlocBuilder<StatisticsBlocType, TodoStatsModel>(
            state: (bloc) => bloc.states.todosStats,
            builder: (context, snapshot, bloc) => StatsWidget(
                  completedCount: snapshot.data?.completed.toString(),
                  incompleteCount: snapshot.data?.incomplete.toString(),
                )),
      );
}
