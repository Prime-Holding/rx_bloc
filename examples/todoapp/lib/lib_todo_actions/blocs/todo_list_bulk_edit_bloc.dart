import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/common_services/todo_list_service.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../models/bulk_action.dart';

part 'todo_list_bulk_edit_bloc.rxb.g.dart';

/// A contract class containing all events of the TodoListBulkEditBloC.
abstract class TodoListBulkEditBlocEvents {
  /// Clear all completed todos.
  ///
  /// This event will trigger the deletion of all completed todos.
  void clearCompleted();

  /// Mark all todos as completed.
  ///
  /// This event will trigger the completion of all todos.
  void markAllCompleted();

  /// Mark all todos as incomplete.
  ///
  /// This event will trigger the uncompletion of all todos.
  void markAllIncomplete();
}

/// A contract class containing all states of the TodoListBulkEditBloC.
abstract class TodoListBulkEditBlocStates {
  /// The list of bulk actions that can be performed.
  ///
  /// This state will be updated whenever the list of bulk actions changes.
  Stream<List<BulkActionModel>> get bulkActions;

  /// The error message.
  Stream<ErrorModel> get errors;
}

@RxBloc()
class TodoListBulkEditBloc extends $TodoListBulkEditBloc {
  TodoListBulkEditBloc(this._todoListService, this._coordinatorBloc);

  final TodoListService _todoListService;
  final CoordinatorBlocType _coordinatorBloc;

  @override
  Stream<List<BulkActionModel>> _mapToBulkActionsState() => Rx.merge([
        _$clearCompletedEvent.switchMap(
          (_) => _todoListService.deleteCompleted().asResultStream(),
        ),
        _$markAllCompletedEvent.switchMap(
          (_) => _todoListService
              .updateCompletedForAll(completed: true)
              .asResultStream(),
        ),
        _$markAllIncompleteEvent.switchMap(
          (_) => _todoListService
              .updateCompletedForAll(completed: false)
              .asResultStream(),
        )
      ])
          .setResultStateHandler(this)
          .doOnData(_coordinatorBloc.events.todoListChanged)
          .mergeWith([_coordinatorBloc.states.onTodoListChanged])
          .whereSuccess()
          .map(
            (todoList) => [
              if (!_todoListService.areAllCompleted(todoList))
                BulkActionModel.markAllComplete,
              if (!_todoListService.areAllIncomplete(todoList))
                BulkActionModel.markAllIncomplete,
              if (_todoListService.hasCompleted(todoList))
                BulkActionModel.clearCompleted,
            ],
          );

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();
}
