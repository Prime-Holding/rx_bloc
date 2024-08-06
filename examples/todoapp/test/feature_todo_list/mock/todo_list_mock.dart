import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/base/models/todos_filter_model.dart';
import 'package:todoapp/feature_todo_list/blocs/todo_list_bloc.dart';

import 'todo_list_mock.mocks.dart';

@GenerateMocks([TodoListBlocStates, TodoListBlocEvents, TodoListBlocType])
TodoListBlocType todoListMockFactory({
  Result<List<TodoModel>>? todoList,
  TodosFilterModel? filter,
  bool? isLoading,
}) {
  final blocMock = MockTodoListBlocType();
  final eventsMock = MockTodoListBlocEvents();
  final statesMock = MockTodoListBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final todoListState = todoList != null
      ? Stream.value(todoList).shareReplay(maxSize: 1)
      : const Stream<Result<List<TodoModel>>>.empty();

  final filterState = filter != null
      ? Stream.value(filter).shareReplay(maxSize: 1)
      : const Stream<TodosFilterModel>.empty();

  final isLoadingState = isLoading != null
      ? Stream.value(isLoading).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();
  when(statesMock.isLoading).thenAnswer((_) => isLoadingState);

  when(statesMock.todoList).thenAnswer((_) => todoListState);
  when(statesMock.filter).thenAnswer((_) => filterState);

  return blocMock;
}
