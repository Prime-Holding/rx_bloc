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
import 'package:todoapp/lib_router/blocs/router_bloc.dart';

import '../../Stubs.dart';
import '../../base/common_blocs/router_bloc_mock.mocks.dart';
import 'todo_details_test.mocks.dart';

@GenerateMocks([
  TodoModel,
  TodoListService,
  CoordinatorBlocType,
  CoordinatorEvents,
  CoordinatorStates,
  TodoDetailsBlocType
])
void main() {
  late TodoListService _todoListService;
  late CoordinatorBlocType _coordinatorBloc;
  late CoordinatorEvents _coordinatorBlocEvents;
  late CoordinatorStates _coordinatorBlocStates;
  late RouterBlocType _routerBloc;
  late RouterBlocEvents _routerBlocEvents;

  void _defineWhen([String? todoId]) {
    when(_todoListService.fetchTodoById(todoId ?? '')).thenAnswer((_) {
      if (todoId?.isNotEmpty != null) {
        return Future.value(Stubs.todoUncompleted);
      }

      return Future.error(Stubs.notFoundError);
    });

    when(_coordinatorBlocStates.onTodoAddedOrUpdated).thenAnswer(
        (_) => Stream.value(Result.success(Stubs.todoUncompletedUpdated)));
  }

  TodoDetailsBloc buildTodoDetailsBloc([String? todoId, TodoModel? initialTodo]) =>
      TodoDetailsBloc(
        todoId ?? '',
        initialTodo,
        _todoListService,
        _coordinatorBloc,
        _routerBloc,
      );

  setUp(() {
    _todoListService = MockTodoListService();
    _coordinatorBloc = MockCoordinatorBlocType();
    _coordinatorBlocStates = MockCoordinatorStates();
    _coordinatorBlocEvents = MockCoordinatorEvents();
    _routerBlocEvents = MockRouterBlocEvents();
    _routerBloc = MockRouterBlocType();

    when(_coordinatorBloc.states).thenReturn(_coordinatorBlocStates);
    when(_coordinatorBloc.events).thenReturn(_coordinatorBlocEvents);
    when(_routerBloc.events).thenReturn(_routerBlocEvents);
  });

  group('test todo_details_bloc_dart state isLoading', () {
    rxBlocTest<TodoDetailsBlocType, bool>(
        'test todo_details_bloc_dart state isLoading',
        build: () async {
          _defineWhen();
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
          _defineWhen(null);
          return buildTodoDetailsBloc(null);
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.errors,
        expect: [
          Stubs.notFoundError,
        ]);
  });

  group('test todo_details_bloc_dart state todo', () {
    rxBlocTest<TodoDetailsBlocType, Result<TodoModel>>(
        'test todo_details_bloc_dart state todo',
        build: () async {
          _defineWhen(Stubs.todoUncompleted.id);
          return buildTodoDetailsBloc(Stubs.todoUncompleted.id);
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.todo,
        expect: [
          Result.loading(),
          Result.success(Stubs.todoUncompleted),
        ]);
  });
}
