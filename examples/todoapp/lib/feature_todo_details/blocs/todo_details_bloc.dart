import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../base/extensions/error_model_extensions.dart';
import '../../../../base/models/errors/error_model.dart';
import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/common_services/todo_list_service.dart';
import '../../base/models/todo_model.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../services/todo_details_service.dart';

part 'todo_details_bloc.rxb.g.dart';

/// A contract class containing all events of the TodoDetailsBloC.
abstract class TodoDetailsBlocEvents {
  /// Delete the todo
  ///
  /// Side effects:
  ///  - Navigates to the previous page
  ///  - Notifies the [CoordinatorBloc] that the todo was deleted
  ///  - Notifies the [RouterBloc] to navigate to the [TodoListRoute]
  void delete();

  /// Notifies the [RouterBloc] to navigate to the [TodoUpdateRoute]
  void manage();

  /// Fetch the todo
  void fetchTodo();
}

/// A contract class containing all states of the TodoDetailsBloC.
abstract class TodoDetailsBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  /// The todo state of the todo details page
  ConnectableStream<TodoModel> get todo;

  /// The state of the todo after it was deleted
  ConnectableStream<TodoModel> get onTodoDeleted;

  /// The state of the routing event
  ConnectableStream<void> get onRouting;
}

@RxBloc()
class TodoDetailsBloc extends $TodoDetailsBloc {
  TodoDetailsBloc(
    this._todoId,
    this._initialTodo,
    this._todoDetailsService,
    this._todoListService,
    this._coordinatorBloc,
    this._routerBloc,
  ) {
    onTodoDeleted.connect().addTo(_compositeSubscription);
    onRouting.connect().addTo(_compositeSubscription);
    todo.connect().addTo(_compositeSubscription);
  }

  final TodoDetailsService _todoDetailsService;
  final TodoListService _todoListService;
  final CoordinatorBlocType _coordinatorBloc;
  final TodoModel? _initialTodo;
  final String _todoId;
  final RouterBlocType _routerBloc;

  @override
  ConnectableStream<TodoModel> _mapToTodoState() => _$fetchTodoEvent
          .startWith(null)
          .switchMap(
            (_) => _todoListService
                .fetchTodoById(_todoId, _initialTodo)
                .asResultStream(),
          )
          .setResultStateHandler(this)
          .whereSuccess()
          .mergeWith([
        _coordinatorBloc.states.onTodoAddedOrUpdated
            .whereSuccess()
            .where((updatedTodo) => _todoId == updatedTodo.id)
      ]).publish();

  @override
  ConnectableStream<TodoModel> _mapToOnTodoDeletedState() => _$deleteEvent
      .withLatestFrom(todo, (_, latestTodo) => latestTodo)
      .switchMap(
          (todo) => _todoDetailsService.deleteTodo(todo).asResultStream())
      .setResultStateHandler(this)
      .doOnData((todoResult) => _coordinatorBloc.events.todoDeleted(todoResult))
      .whereSuccess()
      .doOnData((todo) => _routerBloc.events.go(const TodoListRoute()))
      .publish();

  @override
  ConnectableStream<void> _mapToOnRoutingState() => _$manageEvent
      .withLatestFrom(todo, (_, todo) => todo)
      .doOnData(
        (todo) => _routerBloc.events.go(TodoUpdateRoute(todo.id!), extra: todo),
      )
      .publish();

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}
