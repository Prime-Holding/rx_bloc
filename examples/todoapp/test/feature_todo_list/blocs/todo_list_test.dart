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
  late TodoListService _todoListService;
  late CoordinatorBlocType _coordinatorBloc;
  late CoordinatorStates _coordinatorBlocStates;

  void _defineWhen() {
    when(_todoListService.fetchTodoList())
        .thenAnswer((_) => Future.value(Stubs.todoList));

    when(_todoListService.filterTodos([], TodosFilterModel.all))
        .thenAnswer((_) => []);

    when(_todoListService.filterTodos(Stubs.todoList, TodosFilterModel.all))
        .thenAnswer((_) => Stubs.todoList);

    when(_todoListService.filterTodos(
            Stubs.todoList, TodosFilterModel.completed))
        .thenAnswer(
            (_) => Stubs.todoList.where((todo) => todo.completed).toList());

    when(_todoListService.filterTodos(
            Stubs.todoList, TodosFilterModel.incomplete))
        .thenAnswer(
            (_) => Stubs.todoList.where((todo) => !todo.completed).toList());

    when(_coordinatorBlocStates.onTodoAddedOrUpdated).thenAnswer(
        (_) => Stream.value(Result.success(Stubs.todoUncompletedUpdated)));

    when(_coordinatorBlocStates.onTodoDeleted)
        .thenAnswer((_) => Stream.value(Result.success(Stubs.todoUncompleted)));

    when(_coordinatorBlocStates.onTodoListChanged)
        .thenAnswer((_) => Stream.value(Result.success(Stubs.todoListEmpty)));
  }

  TodoListBloc todoListBloc() => TodoListBloc(
        _todoListService,
        _coordinatorBloc,
      );
  setUp(() {
    _todoListService = MockTodoListService();

    _coordinatorBlocStates = coordinatorStatesMockFactory();

    _coordinatorBloc =
        coordinatorBlocMockFactory(states: _coordinatorBlocStates);

    when(_coordinatorBloc.states).thenReturn(_coordinatorBlocStates);
  });

  group('test todo_list_bloc_dart state filtered todo list', () {
    rxBlocTest<TodoListBlocType, Result<List<TodoModel>>>(
        'test todo_list_bloc_dart state todoList',
        build: () async {
          _defineWhen();
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
          _defineWhen();
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
