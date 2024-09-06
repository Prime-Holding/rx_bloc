import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:todoapp/base/common_blocs/coordinator_bloc.dart';
import 'package:todoapp/base/common_services/todo_list_service.dart';
import 'package:todoapp/base/models/errors/error_model.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/feature_todo_details/blocs/todo_details_bloc.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import '../../base/common_blocs/router_bloc_mock.dart';
import '../../stubs.dart';
import 'todo_details_test.mocks.dart';

@GenerateMocks([TodoModel, TodoListService, TodoDetailsBlocType])
void main() {
  late TodoListService todoListService;
  late CoordinatorBlocType coordinatorBloc;
  late CoordinatorStates coordinatorBlocStates;

  void defineWhen([String? todoId]) {
    when(todoListService.fetchTodoById(todoId ?? '')).thenAnswer((_) {
      if (todoId?.isNotEmpty != null) {
        return Stream.value(Stubs.todoIncomplete);
      }

      return Stream.error(Stubs.notFoundError);
    });

    when(coordinatorBlocStates.onTodoAddedOrUpdated).thenAnswer(
        (_) => Stream.value(Result.success(Stubs.todoUncompletedUpdated)));
  }

  TodoDetailsBloc buildTodoDetailsBloc(
          [String? todoId, TodoModel? initialTodo]) =>
      TodoDetailsBloc(
        todoId ?? '',
        initialTodo,
        todoListService,
        coordinatorBloc,
        routerBlocMockFactory(),
      );

  setUp(() {
    todoListService = MockTodoListService();

    coordinatorBlocStates = coordinatorStatesMockFactory();
    coordinatorBloc = coordinatorBlocMockFactory(states: coordinatorBlocStates);
  });

  group('test todo_details_bloc_dart state isLoading', () {
    rxBlocTest<TodoDetailsBlocType, bool>(
        'test todo_details_bloc_dart state isLoading',
        build: () async {
          defineWhen();
          return buildTodoDetailsBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.isLoading,
        expect: [false, true, false]);
  });

  group('test todo_details_bloc_dart state errors', () {
    rxBlocTest<TodoDetailsBlocType, ErrorModel>(
        'test todo_details_bloc_dart state errors',
        build: () async {
          defineWhen(null);
          return buildTodoDetailsBloc(null);
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.errors,
        expect: [
          Stubs.notFoundError,
        ]);
  });

  group('test todo_details_bloc_dart state todo', () {
    rxBlocTest<TodoDetailsBlocType, Result<$TodoModel>>(
        'test todo_details_bloc_dart state todo',
        build: () async {
          defineWhen(Stubs.todoIncomplete.id);
          return buildTodoDetailsBloc(Stubs.todoIncomplete.id);
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.todo,
        expect: [
          Result.loading(),
          Result.success(Stubs.todoIncomplete),
        ]);
  });
}
