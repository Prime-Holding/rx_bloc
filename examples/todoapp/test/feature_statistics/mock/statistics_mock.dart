import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todoapp/feature_statistics/blocs/statistics_bloc.dart';
import 'package:todoapp/feature_statistics/models/todo_stats_model.dart';

import 'statistics_mock.mocks.dart';

@GenerateMocks([StatisticsBlocStates, StatisticsBlocEvents, StatisticsBlocType])
StatisticsBlocType statisticsMockFactory({
  TodoStatsModel? todosStats,
}) {
  final blocMock = MockStatisticsBlocType();
  final eventsMock = MockStatisticsBlocEvents();
  final statesMock = MockStatisticsBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final todosStatsState = todosStats != null
      ? Stream.value(todosStats).shareReplay(maxSize: 1)
      : const Stream<TodoStatsModel>.empty();

  when(statesMock.todosStats).thenAnswer((_) => todosStatsState);

  return blocMock;
}
