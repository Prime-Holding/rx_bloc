import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/lib_todo_actions/blocs/todo_actions_bloc.dart';

import 'todo_actions_mock.mocks.dart';

@GenerateMocks(
    [TodoActionsBlocStates, TodoActionsBlocEvents, TodoActionsBlocType])
TodoActionsBlocType todoActionsMockFactory({
  TodoModel? onTodoDeleted,
  TodoModel? onUpdateCompleted,
  bool? isLoading,
}) {
  final blocMock = MockTodoActionsBlocType();
  final eventsMock = MockTodoActionsBlocEvents();
  final statesMock = MockTodoActionsBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final onTodoDeletedState = (onTodoDeleted != null
          ? Stream.value(onTodoDeleted)
          : const Stream<TodoModel>.empty())
      .publishReplay(maxSize: 1)
    ..connect();
  final onUpdateCompletedState = (onUpdateCompleted != null
          ? Stream.value(onUpdateCompleted)
          : const Stream<TodoModel>.empty())
      .publishReplay(maxSize: 1)
    ..connect();

  final isLoadingState = isLoading != null
      ? Stream.value(isLoading).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  when(statesMock.onTodoDeleted).thenAnswer((_) => onTodoDeletedState);
  when(statesMock.onUpdateCompleted).thenAnswer((_) => onUpdateCompletedState);
  when(statesMock.isLoading).thenAnswer((_) => isLoadingState);

  return blocMock;
}
