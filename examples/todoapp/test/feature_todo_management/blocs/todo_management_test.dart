import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:todoapp/base/common_blocs/coordinator_bloc.dart';
import 'package:todoapp/base/common_services/todo_list_service.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/feature_todo_management/blocs/todo_management_bloc.dart';
import 'package:todoapp/feature_todo_management/services/todo_manage_service.dart';
import 'package:todoapp/feature_todo_management/services/todo_validator_service.dart';
import 'package:todoapp/lib_router/blocs/router_bloc.dart';

import '../../Stubs.dart';
import '../mock/todo_management_mock.mocks.dart';
import 'todo_management_test.mocks.dart';

@GenerateMocks([
  TodoModel,
  TodoListService,
  TodoManageService,
  TodoValidatorService,
  CoordinatorBlocType,
  CoordinatorEvents,
  CoordinatorStates,
  RouterBlocType,
  TodoManagementBlocEvents,
  TodoManagementBlocStates,
])
void main() {
  late TodoListService _listService;
  late TodoManageService _todoManageService;
  late TodoValidatorService _validatorService;
  late CoordinatorBlocType _coordinatorBloc;
  late CoordinatorEvents _coordinatorBlocEvents;
  late CoordinatorStates _coordinatorBlocStates;
  late TodoManagementBlocEvents _todoManagementBlocEvents;
  late TodoManagementBlocStates _todoManagementBlocStates;
  late RouterBlocType _routerBloc;

  void _defineWhen({String? todoId, String? title, String? description}) {
    when(_listService.fetchTodoById(todoId ?? '')).thenAnswer((_) {
      if (todoId?.isNotEmpty != null) {
        return Future.value(Stubs.todoUncompleted);
      }

      return Future.error(Stubs.notFoundError);
    });

    if (title != null) {
      when(_todoManagementBlocStates.showError).thenAnswer((_) => Stream.value(
              true));
    }

    when(_todoManageService.addOrUpdate(Stubs.todoEmpty
            .copyWith(title: title, description: description ?? '')))
        .thenAnswer((_) => Future.value(Stubs.todoEmpty
            .copyWith(title: title, description: description ?? '')));

    /*when(_validatorService.validateTitle(title ?? '')).thenAnswer((_) {
      if (title != null || title!.trim().isEmpty) {
        throw FieldRequiredErrorModel(
          fieldKey: I18nFieldKeys.title,
          fieldValue: title,
        );
      }
      if (title.length < 3) {
        throw FieldErrorModel(
          errorKey: I18nErrorKeys.tooShort,
          fieldValue: title,
        );
      }
      if (title.length > 30) {
        throw FieldErrorModel(
          errorKey: I18nErrorKeys.tooLong,
          fieldValue: title,
        );
      }
      return title;
    });*/
  }

  TodoManagementBloc todoManagementBloc(
          {String? todoId, TodoModel? initialTodo}) =>
      TodoManagementBloc(
        todoId,
        initialTodo,
        _listService,
        _todoManageService,
        _validatorService,
        _coordinatorBloc,
        _routerBloc,
      );
  setUp(() {
    _listService = MockTodoListService();
    _todoManageService = MockTodoManageService();
    _validatorService = MockTodoValidatorService();
    _coordinatorBloc = MockCoordinatorBlocType();
    _routerBloc = MockRouterBlocType();
    _coordinatorBlocStates = MockCoordinatorStates();
    _coordinatorBlocEvents = MockCoordinatorEvents();
    _todoManagementBlocEvents = MockTodoManagementBlocEvents();
    _todoManagementBlocStates = MockTodoManagementBlocStates();

    when(_coordinatorBloc.states).thenReturn(_coordinatorBlocStates);
    when(_coordinatorBloc.events).thenReturn(_coordinatorBlocEvents);
  });

  group('test todo_management_bloc_dart state title', () {
    rxBlocTest<TodoManagementBlocType, String>(
        'test todo_management_bloc_dart state title',
        build: () async {
          _defineWhen(
              todoId: Stubs.todoUncompleted.id,
              title: Stubs.todoUncompleted.title);
          return todoManagementBloc(todoId: Stubs.todoUncompleted.id);
        },
        act: (bloc) async {
          bloc.events.setTitle(Stubs.todoUncompleted.title);
          bloc.events.save();
        },
        state: (bloc) => bloc.states.title,
        expect: [Stubs.todoUncompleted.title]);
  });

  group('test todo_management_bloc_dart state description', () {
    rxBlocTest<TodoManagementBlocType, String>(
        'test todo_management_bloc_dart state description',
        build: () async {
          _defineWhen();
          return todoManagementBloc();
        },
        act: (bloc) async {
          bloc.events.setDescription(Stubs.todoCompleted.description);
        },
        state: (bloc) => bloc.states.description,
        expect: [Stubs.todoCompleted.description]);
  });

  group('test todo_management_bloc_dart state showError', () {
    rxBlocTest<TodoManagementBlocType, bool>(
        'test todo_management_bloc_dart state showError',
        build: () async {
          _defineWhen(title: Stubs.shortTitle);
          return todoManagementBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.showError,
        expect: [true]);
  });

  group('test todo_management_bloc_dart state isLoading', () {
    rxBlocTest<TodoManagementBlocType, bool>(
        'test todo_management_bloc_dart state isLoading',
        build: () async {
          _defineWhen();
          return todoManagementBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.isLoading,
        expect: [false]);
  });
}
