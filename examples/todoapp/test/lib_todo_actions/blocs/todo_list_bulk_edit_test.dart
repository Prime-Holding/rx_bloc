import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:todoapp/base/common_blocs/coordinator_bloc.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/base/repositories/todo_list_repository.dart';
import 'package:todoapp/lib_todo_actions/blocs/todo_list_bulk_edit_bloc.dart';
import 'package:todoapp/lib_todo_actions/models/bulk_action.dart';
import 'package:todoapp/lib_todo_actions/services/todo_actions_service.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import '../../stubs.dart';
import 'todo_list_bulk_edit_test.mocks.dart';

@GenerateMocks([
  TodoListRepository,
])
Future<void> main() async {
  late CoordinatorBlocType _coordinatorBloc;
  late CoordinatorStates _coordinatorStates;
  late TodoListRepository _repository;

  void _defineWhen(List<TodoModel> todoList, List<TodoModel> deleteCompletedResult) {
    when(_coordinatorStates.onTodoListChanged)
        .thenAnswer((_) => Stream.value(Result.success(todoList)));

    when(_repository.updateCompletedForAll(true)).thenAnswer((_)  => Future.value(Stubs.todoListAllCompleted));

    when(_repository.updateCompletedForAll(false)).thenAnswer((_) => Future.value(Stubs.todoListAllIncomplete));

    when(_repository.deleteCompleted()).thenAnswer((_) => Future.value(deleteCompletedResult));
  }

  TodoListBulkEditBloc bloc() => TodoListBulkEditBloc(
        TodoActionsService(_repository),
        _coordinatorBloc,
      );

  setUp(() {
    _repository = MockTodoListRepository();
    _coordinatorStates = coordinatorStatesMockFactory();
    _coordinatorBloc = coordinatorBlocMockFactory(states: _coordinatorStates);
  });

  rxBlocFakeAsyncTest<TodoListBulkEditBlocType, List<BulkActionModel>>(
      'test todo_list_bulk_edit_test state bulkActions',
      build: () {
        _defineWhen(Stubs.todoList, []);
        return bloc();
      },
      act: (bloc, fakeAsync) async {
        bloc.events.markAllIncomplete();
        fakeAsync.elapse(const Duration(milliseconds: 1));
        bloc.events.markAllCompleted();
        fakeAsync.elapse(const Duration(milliseconds: 1));
        bloc.events.clearCompleted();
      },
      state: (bloc) => bloc.states.bulkActions,
      expect: [
        [
          BulkActionModel.markAllComplete,
          BulkActionModel.markAllIncomplete,
          BulkActionModel.clearCompleted
        ],
        [BulkActionModel.markAllComplete],
        [BulkActionModel.markAllIncomplete, BulkActionModel.clearCompleted],
        []
      ]);
}
