import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:todoapp/base/common_blocs/coordinator_bloc.dart';
import 'package:todoapp/base/models/todo_model.dart';

import '../../stubs.dart';

@GenerateMocks([
  CoordinatorBlocType,
])
void main() {
  void _defineWhen() {}

  CoordinatorBloc coordinatorBloc() => CoordinatorBloc();
  setUp(() {});

  group('test coordinator_bloc_dart states', () {
    rxBlocTest<CoordinatorBlocType, Result<TodoModel>>(
        'test coordinator_bloc_dart state  onTodoAddedOrUpdated',
        build: () async {
          _defineWhen();
          return coordinatorBloc();
        },
        act: (bloc) async {
          bloc.events.todoAddedOrUpdated(Result.loading());
          bloc.events.todoAddedOrUpdated(Result.success(Stubs.todoCompleted));
          bloc.events.todoAddedOrUpdated(Result.success(Stubs.todoUncompleted));
        },
        state: (bloc) => bloc.states.onTodoAddedOrUpdated,
        expect: [
          Result.loading(),
          Result.success(Stubs.todoCompleted),
          Result.success(Stubs.todoUncompleted),
        ]);

    rxBlocTest<CoordinatorBlocType, bool>(
        'test coordinator_bloc_dart state  onTodoAddedOrUpdated',
        build: () async {
          _defineWhen();
          return coordinatorBloc();
        },
        act: (bloc) async {
          bloc.events.authenticated(isAuthenticated: true);
          bloc.events.authenticated(isAuthenticated: false);
          bloc.events.authenticated(isAuthenticated: true);
        },
        state: (bloc) => bloc.states.isAuthenticated,
        expect: [
          true,
          false,
          true,
        ]);

    rxBlocTest<CoordinatorBlocType, Result<TodoModel>>(
        'test coordinator_bloc_dart state  onTodoDeleted',
        build: () async {
          _defineWhen();
          return coordinatorBloc();
        },
        act: (bloc) async {
          bloc.events.todoDeleted(Result.loading());
          bloc.events.todoDeleted(Result.success(Stubs.todoCompleted));
          bloc.events.todoDeleted(Result.success(Stubs.todoUncompleted));
        },
        state: (bloc) => bloc.states.onTodoDeleted,
        expect: [
          Result.loading(),
          Result.success(Stubs.todoCompleted),
          Result.success(Stubs.todoUncompleted),
        ]);

    rxBlocTest<CoordinatorBlocType, Result<List<TodoModel>>>(
        'test coordinator_bloc_dart state  onTodoListChanged',
        build: () async {
          _defineWhen();
          return coordinatorBloc();
        },
        act: (bloc) async {
          bloc.events.todoListChanged(Result.loading());
          bloc.events.todoListChanged(Result.success(Stubs.todoList));
          bloc.events.todoListChanged(Result.success(Stubs.todoListEmpty));
        },
        state: (bloc) => bloc.states.onTodoListChanged,
        expect: [
          Result.loading(),
          Result.success(Stubs.todoList),
          Result.success(Stubs.todoListEmpty),
        ]);
  });
}
