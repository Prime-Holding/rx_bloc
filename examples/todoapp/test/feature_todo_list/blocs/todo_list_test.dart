import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:todoapp/base/common_blocs/coordinator_bloc.dart';
import 'package:todoapp/base/common_services/todo_list_service.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/base/models/todos_filter_model.dart';
import 'package:todoapp/feature_todo_list/blocs/todo_list_bloc.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import '../../stubs.dart';
import 'todo_list_test.mocks.dart';

@GenerateMocks([
  TodoListService,
])
void main() {
  late TodoListService todoListService;
  late CoordinatorBlocType coordinatorBloc;
  late CoordinatorStates coordinatorBlocStates;

  void defineWhen(
      {List<TodoModel>? todoList,
      TodoModel? updatedTodo,
      TodoModel? deletedModel,
      List<TodoModel>? changedTodoList}) {
    todoList ??= Stubs.todoList;
    updatedTodo ??= Stubs.todoUncompletedUpdated;
    deletedModel ??= Stubs.todoIncomplete;
    changedTodoList ??= Stubs.todoListEmpty;

    when(todoListService.fetchTodoList())
        .thenAnswer((_) => Future.value(todoList));

    when(todoListService.filterTodos([], TodosFilterModel.all))
        .thenAnswer((_) => []);

    when(todoListService.filterTodos(todoList, TodosFilterModel.all))
        .thenAnswer((_) => todoList!);

    when(todoListService.filterTodos(todoList, TodosFilterModel.completed))
        .thenAnswer((_) => todoList!.where((todo) => todo.completed).toList());

    when(todoListService.filterTodos(todoList, TodosFilterModel.incomplete))
        .thenAnswer((_) => todoList!.where((todo) => !todo.completed).toList());

    when(coordinatorBlocStates.onTodoAddedOrUpdated)
        .thenAnswer((_) => Stream.value(Result.success(updatedTodo!)));

    when(coordinatorBlocStates.onTodoDeleted)
        .thenAnswer((_) => Stream.value(Result.success(deletedModel!)));

    when(coordinatorBlocStates.onTodoListChanged)
        .thenAnswer((_) => Stream.value(Result.success(changedTodoList!)));
  }

  TodoListBloc todoListBloc() => TodoListBloc(
        todoListService,
        coordinatorBloc,
      );
  setUp(() {
    todoListService = MockTodoListService();

    coordinatorBlocStates = coordinatorStatesMockFactory();

    coordinatorBloc = coordinatorBlocMockFactory(states: coordinatorBlocStates);

    when(coordinatorBloc.states).thenReturn(coordinatorBlocStates);
  });

  group('test todo_list_bloc_dart state filtered todo list', () {
    rxBlocTest<TodoListBlocType, Result<List<TodoModel>>>(
        'test todo_list_bloc_dart state todoList',
        build: () async {
          defineWhen(todoList: Stubs.todoList);
          return todoListBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.todoList,
        expect: [
          Result.success([]),
          Result.loading(),
          Result.success(Stubs.todoList)
        ]);

    rxBlocTest<TodoListBlocType, TodosFilterModel>(
        'test todo_list_bloc_dart state filter',
        build: () async {
          defineWhen();
          return todoListBloc();
        },
        act: (bloc) async {
          bloc.events.applyFilter(TodosFilterModel.all);
          bloc.states.filter;
        },
        state: (bloc) => bloc.states.filter,
        expect: [TodosFilterModel.all]);
  });
}
