import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/models/todo_model.dart';

import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../services/todo_actions_service.dart';

part 'todo_actions_bloc.rxb.g.dart';

/// A contract class containing all events of the TodoActionsBloC
abstract class TodoActionsBlocEvents {
  /// Updates the completed status of a todo by its [id].
  ///
  /// This event will trigger the update of the completed status of a
  /// todo and [TodoListBlocStates.todoList] will emit the updated list.
  void updateCompletedById(String id, bool completed);

  /// Delete the todo
  ///
  /// Side effects:
  ///  - Navigates to the previous page
  ///  - Notifies the [CoordinatorBloc] that the todo was deleted
  ///  - Notifies the [RouterBloc] to navigate to the [TodoListRoute]
  void delete(String id);
}

/// A contract class containing all states of the TodoActionsBloC.
abstract class TodoActionsBlocStates {
  /// The state of the todo after it was deleted
  ConnectableStream<$TodoModel> get onTodoDeleted;
  ConnectableStream<$TodoModel> get onUpdateCompleted;
  Stream<bool> get isLoading;
}

@RxBloc()
class TodoActionsBloc extends $TodoActionsBloc {
  TodoActionsBloc(
    this._todoActionsService,
    this._coordinatorBloc,
    this._routerBloc,
  ) {
    onTodoDeleted.connect().addTo(_compositeSubscription);
    onUpdateCompleted.connect().addTo(_compositeSubscription);
  }

  final TodoActionsService _todoActionsService;

  final CoordinatorBlocType _coordinatorBloc;
  final RouterBlocType _routerBloc;

  @override
  ConnectableStream<$TodoModel> _mapToOnTodoDeletedState() => _$deleteEvent
      .switchMap(
        (id) => _todoActionsService.deleteTodoById(id).asResultStream(),
      )
      .setResultStateHandler(this)
      .doOnData((todoResult) => _coordinatorBloc.events.todoDeleted(todoResult))
      .whereSuccess()
      .doOnData((todo) => _routerBloc.events.go(const TodoListRoute()))
      .publish();

  @override
  ConnectableStream<$TodoModel> _mapToOnUpdateCompletedState() =>
      _$updateCompletedByIdEvent
          .switchMap((args) => _todoActionsService
              .updateCompletedById(args.id, args.completed)
              .asResultStream())
          .setResultStateHandler(this)
          // Emits the updated todo list to the [CoordinatorBloc]
          .doOnData(_coordinatorBloc.events.todoAddedOrUpdated)
          .whereSuccess()
          .publish();
  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}
