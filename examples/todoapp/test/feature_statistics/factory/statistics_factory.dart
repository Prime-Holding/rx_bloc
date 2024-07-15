import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/feature_statistics/blocs/statistics_bloc.dart';
import 'package:todoapp/feature_statistics/models/todo_stats_model.dart';
import 'package:todoapp/feature_statistics/views/statistics_page.dart';
import 'package:todoapp/lib_todo_actions/blocs/todo_list_bulk_edit_bloc.dart';

import '../../lib_todo_actions/mock/todo_list_bulk_edit_mock.dart';
import '../mock/statistics_mock.dart';

/// Change the parameters according the the needs of the test
Widget statisticsFactory({
  TodoStatsModel? todosStats,
}) =>
    Scaffold(
      body: MultiProvider(providers: [
        RxBlocProvider<StatisticsBlocType>.value(
          value: statisticsMockFactory(
            todosStats: todosStats,
          ),
        ),
        RxBlocProvider<TodoListBulkEditBlocType>.value(
          value: todoListBulkEditMockFactory(),
        ),
      ], child: const StatisticsPage()),
    );
