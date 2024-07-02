import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:todoapp/base/common_blocs/coordinator_bloc.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/feature_statistics/blocs/statistics_bloc.dart';
import 'package:todoapp/feature_statistics/models/todo_stats_model.dart';
import 'package:todoapp/feature_statistics/services/statistics_service.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import '../../stubs.dart';

@GenerateMocks([
  StatisticsService,
])
void main() {
  late CoordinatorBlocType _coordinatorBloc;
  late CoordinatorStates _coordinatorStates;
  late StatisticsService _service;

  void _defineWhen(List<TodoModel> todoList) {
    when(_coordinatorStates.onTodoListChanged).thenAnswer((_) => Stream.value(Result.success(todoList)));
  }

  StatisticsBloc statisticsBloc() => StatisticsBloc(
        _coordinatorBloc,
        _service,
      );
  setUp(() {
    _service = StatisticsService();
    _coordinatorStates = coordinatorStatesMockFactory();
    _coordinatorBloc = coordinatorBlocMockFactory(states: _coordinatorStates);
  });

  group('test statistics_bloc_dart state todosStats', () {
    rxBlocTest<StatisticsBlocType, TodoStatsModel>(
        'test statistics_bloc_dart state todosStats',
        build: () async {
          _defineWhen(Stubs.todoList);
          return statisticsBloc();
        },
        act: (bloc) async {
          _coordinatorBloc.events
              .todoListChanged(Result.success(Stubs.todoList));
        },
        state: (bloc) => bloc.states.todosStats,
        expect: [Stubs.todoListStatistics]);
  });
}
