import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:todoapp/base/common_blocs/coordinator_bloc.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/lib_todo_actions/blocs/todo_actions_bloc.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import '../../base/common_blocs/router_bloc_mock.dart';
import '../../stubs.dart';
import 'todo_action_service_mock.dart';
import 'todo_action_service_mock.mocks.dart';

void main() {
  late CoordinatorBlocType coordinatorBloc;
  late MockTodoActionsService service;

  TodoActionsBloc bloc() => TodoActionsBloc(
        service,
        coordinatorBloc,
        routerBlocMockFactory(),
      );

  setUp(() {
    service = todoActionsServiceMockFactory();
    coordinatorBloc = coordinatorBlocMockFactory();
  });

  rxBlocTest<TodoActionsBlocType, $TodoModel>(
      'test todo_actions_test_dart state onTodoDeleted',
      build: () async {
        when(service.deleteTodoById(any))
            .thenAnswer((_) async => Stubs.todoCompleted);
        return bloc();
      },
      act: (bloc) async {
        bloc.events.delete(Stubs.todoCompleted.id!);
      },
      state: (bloc) => bloc.states.onTodoDeleted,
      expect: [Stubs.todoCompleted]);

  rxBlocTest<TodoActionsBloc, $TodoModel>(
      'test todo_actions_test_dart state onUpdateCompleted',
      build: () async {
        when(service.updateCompletedById(any, true))
            .thenAnswer((_) async => Stubs.getCompletedTodo());

        when(service.updateCompletedById(any, false))
            .thenAnswer((_) async => Stubs.getIncompleteTodo());
        return bloc();
      },
      act: (bloc) async {
        bloc.updateCompletedById(Stubs.getCompletedTodo().id!, false);
      },
      state: (bloc) => bloc.states.onUpdateCompleted,
      expect: [
        Stubs.getIncompleteTodo(),
      ]);
  rxBlocTest<TodoActionsBloc, bool>(
    'test todo_actions_test_dart state _mapToIsLoadingState',
    build: () async {
      return bloc();
    },
    act: (bloc) async {
      bloc.events.delete(Stubs.todoCompleted.id!);
    },
    state: (bloc) => bloc.isLoading,
    expect: [
      false,
    ],
  );
}
