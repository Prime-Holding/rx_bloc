import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/common_services/todo_list_service.dart';
import '../../base/extensions/subject_extensions.dart';
import '../../base/extensions/todo_list_extensions.dart';
import '../../base/models/todo_model.dart';
import '../../base/models/todos_filter_model.dart';

part 'todo_list_bloc.rxb.g.dart';

/// A contract class containing all events of the TodoListBloC.
abstract class TodoListBlocEvents {
  /// Fetches the todo list.
  ///
  /// This event will trigger the fetching and its result can will be emitted to the [TodoListBlocStates.todoList].
  void fetchTodoList();

  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: TodosFilterModel.all)
  void applyFilter(TodosFilterModel filter);
}

/// A contract class containing all states of the TodoListBloC.
abstract class TodoListBlocStates {
  /// Emits the todo list.
  ///
  /// The todo list will be filtered based on the [TodoListBlocEvents.applyFilter] event.
  /// The default filter is [TodosFilterModel.all].
  Stream<Result<List<$TodoModel>>> get todoList;

  @RxBlocIgnoreState()
  Stream<TodosFilterModel> get filter;

  Stream<bool> get isLoading;
}

@RxBloc()
class TodoListBloc extends $TodoListBloc {
  TodoListBloc(
    this._todoListService,
    this._coordinatorBloc,
  ) {
    _$fetchTodoListEvent
        .startWith(null)
        // Fetches the todo list and emits the result to the [TodoListBlocStates.todoList]
        .switchMap(
          (value) => _todoListService.fetchTodoList().asResultStream(),
        )
        .setResultStateHandler(this)
        // Merges the todo list with the updated todo list from the [CoordinatorBloc] and emits the result to the [TodoListBlocStates.todoList]
        .mergeWith([
          _coordinatorBloc.states.onTodoAddedOrUpdated
              .whereSuccess()
              .withLatestFromIdentifiableList(_todoResult.whereSuccess(),
                  operationCallback:
                      ($TodoModel todo, List<$TodoModel> list) async =>
                          ManageOperation.merge)
              .map((managedList) => managedList.list.sortByCreatedAt())
              .mapToResult(),
          _coordinatorBloc.states.onTodoDeleted
              .whereSuccess()
              .withLatestFromIdentifiableList(_todoResult.whereSuccess(),
                  operationCallback:
                      ($TodoModel todo, List<$TodoModel> list) async =>
                          ManageOperation.remove)
              .map((managedList) => managedList.list.sortByCreatedAt())
              .mapToResult(),
        ])
        .doOnData(_coordinatorBloc.events.todoListChanged)
        // Merges the todo list with the updated todo list from the [CoordinatorBloc] and emits the result to the [TodoListBlocStates.todoList]
        .mergeWith([
          _coordinatorBloc.states.onTodoListChanged
              .whereSuccess()
              .asResultStream()
        ])
        .bind(_todoResult)
        .addTo(_compositeSubscription);
  }

  final TodoListService _todoListService;
  final CoordinatorBlocType _coordinatorBloc;

  final _todoResult = BehaviorSubject<Result<List<$TodoModel>>>();

  @override
  Stream<Result<List<$TodoModel>>> _mapToTodoListState() => Rx.combineLatest2(
          _todoResult,
          _$applyFilterEvent,
          (listResult, filter) => listResult
              .mapResult((list) => _todoListService.filterTodos(list, filter)))
      .shareReplay(maxSize: 1);

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<TodosFilterModel> get filter => _$applyFilterEvent;

  /// Disposes of all streams to prevent memory leaks
  @override
  void dispose() {
    _todoResult.closeSafely();
    super.dispose();
  }
}
