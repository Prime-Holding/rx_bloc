import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todoapp/lib_todo_actions/blocs/todo_list_bulk_edit_bloc.dart';
import 'package:todoapp/lib_todo_actions/models/bulk_action.dart';

import 'todo_list_bulk_edit_mock.mocks.dart';

@GenerateMocks([
  TodoListBulkEditBlocStates,
  TodoListBulkEditBlocEvents,
  TodoListBulkEditBlocType
])
TodoListBulkEditBlocType todoListBulkEditMockFactory() {
  final blocMock = MockTodoListBulkEditBlocType();
  final eventsMock = MockTodoListBulkEditBlocEvents();
  final statesMock = MockTodoListBulkEditBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  /*
  final bulkActionsState = bulkActions != null
      ? 
      : const Stream<List<BulkActionModel>>.empty();*/

  when(statesMock.bulkActions).thenAnswer((_) => Stream.value([
    BulkActionModel.markAllComplete,
    BulkActionModel.markAllIncomplete,
    BulkActionModel.clearCompleted,
  ]));






  return blocMock;
}
