import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:todoapp/base/common_blocs/coordinator_bloc.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/lib_todo_actions/blocs/todo_actions_bloc.dart';
import 'package:todoapp/lib_todo_actions/services/todo_actions_service.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import '../../base/common_blocs/router_bloc_mock.dart';
import '../../stubs.dart';
import 'todo_action_service_mock.dart';

void main() {
  late CoordinatorBlocType _coordinatorBloc;
  late TodoActionsService _service;

  void _defineWhen({String? todoId, TodoModel? todo}) {
    if (todoId != null && todo != null) {
      when(_service.deleteTodoById(todoId))
          .thenAnswer((_) => Future.value(todo));

      when(_service.updateCompletedById(todoId, true))
          .thenAnswer((_) => Future.value(todo.copyWith(completed: true)));

      when(_service.updateCompletedById(todoId, false))
          .thenAnswer((_) => Future.value(todo.copyWith(completed: false)));
    }
  }

  TodoActionsBloc bloc() => TodoActionsBloc(
        _service,
        _coordinatorBloc,
        routerBlocMockFactory(),
      );

  setUp(() {
    _service = todoActionsServiceMockFactory();
    _coordinatorBloc = coordinatorBlocMockFactory();
  });

  rxBlocTest<TodoActionsBlocType, TodoModel>(
      'test todo_actions_test_dart state onTodoDeleted',
      build: () async {
        _defineWhen(todoId: Stubs.todoCompleted.id!, todo: Stubs.todoCompleted);
        return bloc();
      },
      act: (bloc) async {
        bloc.events.delete(Stubs.todoCompleted.id!);
      },
      state: (bloc) => bloc.states.onTodoDeleted,
      expect: [Stubs.todoCompleted]);

  rxBlocFakeAsyncTest<TodoActionsBlocType, TodoModel>(
      'test todo_actions_test_dart state onUpdateCompleted',
      build: () {
        _defineWhen(todoId: Stubs.todoCompleted.id!, todo: Stubs.todoCompleted);
        return bloc();
      },
      act: (bloc, fakeAsync) async {
        fakeAsync.elapse(const Duration(milliseconds: 1));
        bloc.events.updateCompletedById(
            Stubs.todoCompleted.id!, !Stubs.todoCompleted.completed);
        fakeAsync.elapse(const Duration(milliseconds: 1));
        bloc.events.updateCompletedById(Stubs.todoCompleted.id!, true);
        fakeAsync.elapse(const Duration(milliseconds: 1));
        bloc.events.updateCompletedById(Stubs.todoCompleted.id!, false);
      },
      state: (bloc) => bloc.states.onUpdateCompleted,
      expect: [
        Stubs.todoCompleted.copyWith(completed: !Stubs.todoCompleted.completed),
        Stubs.todoCompleted.copyWith(completed: true),
        Stubs.todoCompleted.copyWith(completed: false),
      ]);
}
