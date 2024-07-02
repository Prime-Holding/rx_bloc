import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:todoapp/base/common_blocs/coordinator_bloc.dart';
import 'package:todoapp/base/common_services/todo_list_service.dart';
import 'package:todoapp/base/models/errors/error_model.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/feature_todo_management/blocs/todo_management_bloc.dart';
import 'package:todoapp/feature_todo_management/services/todo_manage_service.dart';
import 'package:todoapp/feature_todo_management/services/todo_validator_service.dart';
import 'package:todoapp/lib_router/blocs/router_bloc.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import '../../base/common_blocs/router_bloc_mock.dart';
import '../../stubs.dart';
import 'todo_management_test.mocks.dart';

@GenerateMocks([
  TodoListService,
  TodoManageService,
  TodoValidatorService,
  RouterBlocType,
  TodoManagementBlocEvents,
  TodoManagementBlocStates,
  TodoManagementBlocType,
])
void main() {
  late TodoListService _listService;
  late TodoManageService _todoManageService;
  late TodoValidatorService _validatorService;
  late CoordinatorBlocType _coordinatorBloc;

  void _defineWhen(
      {String? todoId,
      String? title,
      String? description = '',
      TodoModel? todoModel}) {
    when(_listService.fetchTodoById(todoId ?? '')).thenAnswer((_) {
      if (todoId?.isNotEmpty != null) {
        return Future.value(todoModel);
      }

      return Future.error(Stubs.notFoundError);
    });

    when(_todoManageService.addOrUpdate(
            Stubs.todoEmpty.copyWith(title: title, description: description)))
        .thenAnswer((_) => Future.value(
            Stubs.todoEmpty.copyWith(title: title, description: description)));
  }

  TodoManagementBloc todoManagementBloc(
          {String? todoId, TodoModel? initialTodo}) =>
      TodoManagementBloc(
        todoId ?? '',
        initialTodo,
        _listService,
        _todoManageService,
        _validatorService,
        _coordinatorBloc,
        routerBlocMockFactory(),
      );
  setUp(() {
    _listService = MockTodoListService();
    _todoManageService = MockTodoManageService();
    _validatorService = TodoValidatorService();
    _coordinatorBloc = coordinatorBlocMockFactory();
  });

  group('test todo_management_bloc_dart state todo', () {
    rxBlocTest<TodoManagementBlocType, String>(
        'test todo_management_bloc_dart state title',
        build: () async {
          _defineWhen(title: Stubs.todoUncompleted.title);
          return todoManagementBloc();
        },
        act: (bloc) async {
          bloc.events.setTitle(Stubs.todoUncompleted.title);
        },
        state: (bloc) => bloc.states.title,
        expect: [Stubs.todoUncompleted.title]);

    rxBlocTest<TodoManagementBlocType, String>(
        'test todo_management_bloc_dart state invalid title',
        build: () async {
          _defineWhen(title: Stubs.shortTitle);
          return todoManagementBloc();
        },
        act: (bloc) async {
          bloc.events.setTitle(Stubs.shortTitle);
        },
        state: (bloc) => bloc.states.title,
        expect: [emitsError(isA<FieldErrorModel>())]);

    rxBlocTest<TodoManagementBlocType, String>(
        'test todo_management_bloc_dart state description',
        build: () async {
          _defineWhen(description: Stubs.todoCompleted.description);
          return todoManagementBloc();
        },
        act: (bloc) async {
          bloc.events.setDescription(Stubs.todoCompleted.description);
        },
        state: (bloc) => bloc.states.description,
        expect: ['', Stubs.todoCompleted.description]);
  });

  group('test todo_management_bloc_dart state errors', () {
    rxBlocTest<TodoManagementBlocType, ErrorModel>(
        'test todo_management_bloc_dart state errors',
        build: () async {
          _defineWhen(todoId: null);
          return todoManagementBloc(todoId: null);
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.errors,
        expect: [
          Stubs.notFoundError,
        ]);
  });
}
