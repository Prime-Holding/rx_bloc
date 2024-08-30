import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/base/models/todos_filter_model.dart';
import 'package:todoapp/feature_todo_list/blocs/todo_list_bloc.dart';

import '../../feature_todo_list/mock/todo_list_mock.mocks.dart';

@GenerateMocks([TodoListBlocStates, TodoListBlocEvents, TodoListBlocType])
TodoListBlocType todoListBlocMockFactory({
  Result<List<TodoModel>>? todosList,
  TodosFilterModel? filter,
}) {
  final blocMock = MockTodoListBlocType();
  final eventsMock = MockTodoListBlocEvents();
  final statesMock = MockTodoListBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final todoState = (todosList != null
          ? Stream.value(todosList)
          : const Stream<Result<List<TodoModel>>>.empty())
      .publishReplay(maxSize: 1)
    ..connect();

  final filterState = filter != null
      ? Stream.value(filter).shareReplay(maxSize: 1)
      : const Stream<TodosFilterModel>.empty();

  when(statesMock.todoList).thenAnswer((_) => todoState);
  when(statesMock.filter).thenAnswer((_) => filterState);

  return blocMock;
}
