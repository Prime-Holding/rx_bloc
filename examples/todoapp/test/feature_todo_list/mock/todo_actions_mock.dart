import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todoapp/lib_todo_actions/blocs/todo_actions_bloc.dart';

import 'todo_actions_mock.mocks.dart';

@GenerateMocks(
    [TodoActionsBlocStates, TodoActionsBlocEvents, TodoActionsBlocType])
TodoActionsBlocType todoActionsMockFactory() {
  final blocMock = MockTodoActionsBlocType();
  final eventsMock = MockTodoActionsBlocEvents();
  final statesMock = MockTodoActionsBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);
/*
  when(statesMock.onTodoDeleted)
      .thenAnswer((_) => Stream.value(Stubs.todoCompleted).publish()..connect());
  when(statesMock.onUpdateCompleted).thenAnswer((_) =>
      Stream.value(Stubs.todoCompleted.copyWith(title: 'new')).publish()..connect());*/

  return blocMock;
}
