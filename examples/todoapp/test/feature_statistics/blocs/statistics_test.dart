import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:todoapp/base/common_blocs/coordinator_bloc.dart';
import 'package:todoapp/feature_statistics/blocs/statistics_bloc.dart';
import 'package:todoapp/feature_statistics/models/todo_stats_model.dart';
import 'package:todoapp/feature_statistics/services/statistics_service.dart';

import '../../Stubs.dart';
import 'statistics_test.mocks.dart';

@GenerateMocks([
  CoordinatorBlocType,
  CoordinatorEvents,
  CoordinatorStates,
  StatisticsService,
])
void main() {
  late CoordinatorBlocType _coordinatorBloc;
  late CoordinatorEvents _coordinatorEvents;
  late CoordinatorStates _coordinatorStates;
  late StatisticsService _service;

  void _defineWhen() {
    when(_coordinatorStates.onTodoListChanged)
        .thenAnswer((_) => Stream.value(Result.success(Stubs.todoList)));
    when(_service.calculateStats(Stubs.todoList))
        .thenAnswer((_) => Stubs.todoListStatistics);
  }

  StatisticsBloc statisticsBloc() => StatisticsBloc(
        _coordinatorBloc,
        _service,
      );
  setUp(() {
    _coordinatorBloc = MockCoordinatorBlocType();
    _service = MockStatisticsService();
    _coordinatorStates = MockCoordinatorStates();
    _coordinatorEvents = MockCoordinatorEvents();

    when(_coordinatorBloc.states).thenReturn(_coordinatorStates);
    when(_coordinatorBloc.events).thenReturn(_coordinatorEvents);
  });

  group('test statistics_bloc_dart state todosStats', () {
    rxBlocTest<StatisticsBlocType, TodoStatsModel>(
        'test statistics_bloc_dart state todosStats',
        build: () async {
          _defineWhen();
          return statisticsBloc();
        },
        act: (bloc) async {
          _coordinatorBloc.events.todoListChanged(Result.success(Stubs.todoList));
        },
        state: (bloc) => bloc.states.todosStats,
        expect: [Stubs.todoListStatistics]);
  });
}
