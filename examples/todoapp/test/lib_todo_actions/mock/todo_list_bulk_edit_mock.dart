import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todoapp/lib_todo_actions/blocs/todo_list_bulk_edit_bloc.dart';
import 'package:todoapp/lib_todo_actions/models/bulk_action.dart';

import 'todo_list_bulk_edit_mock.mocks.dart';

@GenerateMocks([
  TodoListBulkEditBlocStates,
  TodoListBulkEditBlocEvents,
  TodoListBulkEditBlocType
])
TodoListBulkEditBlocType todoListBulkEditMockFactory({
  bool? isLoading,
}) {
  final blocMock = MockTodoListBulkEditBlocType();
  final eventsMock = MockTodoListBulkEditBlocEvents();
  final statesMock = MockTodoListBulkEditBlocStates();

  final isLoadingState = isLoading != null
      ? Stream.value(isLoading).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();
  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  when(statesMock.bulkActions).thenAnswer((_) => Stream.value([
        BulkActionModel.markAllComplete,
        BulkActionModel.markAllIncomplete,
        BulkActionModel.clearCompleted,
      ]));
  when(statesMock.isLoading).thenAnswer((_) => isLoadingState);

  return blocMock;
}
