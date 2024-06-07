import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../base/extensions/error_model_extensions.dart';
import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/common_services/todo_list_service.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/models/todo_model.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';

import '../services/todo_manage_service.dart';
import '../services/todo_validator_service.dart';

part 'todo_management_bloc.rxb.g.dart';

/// A contract class containing all events of the TodoManagementBloC.
abstract class TodoManagementBlocEvents {
  /// Fetches the todo.
  ///
  /// This event will trigger the fetching of the todo and its result will be emitted to the [TodoManagementBlocStates.todo].
  void fetchTodo();

  /// Sets the title of the todo.
  ///
  /// Side effects:
  /// - Emits the new title or an [ErrorModel] to the [TodoManagementBlocStates.title].
  void setTitle(String title);

  /// Sets the description of the todo.
  ///
  /// Side effects:
  /// - Emits the new description or an [ErrorModel] to the [TodoManagementBlocStates.description].
  void setDescription(String? description);

  /// Create or update the todo.
  void save();
}

/// A contract class containing all states of the TodoManagementBloC.
abstract class TodoManagementBlocStates {
  /// The stream of the title or an [ErrorModel] if the title is invalid.
  Stream<String> get title;

  /// The stream of the description or an [ErrorModel] if the description is invalid.
  Stream<String> get description;

  /// The stream of the error state. The error is shown if the title is empty.
  Stream<bool> get showError;

  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  /// The state of the routing event
  ConnectableStream<TodoModel> get onTodoSaved;

  @RxBlocIgnoreState()
  bool get isEditingTodo;
}

@RxBloc()
class TodoManagementBloc extends $TodoManagementBloc {
  TodoManagementBloc(
    this._id,
    TodoModel? initialTodo,
    this._listService,
    this._todoManageService,
    this._validatorService,
    this._coordinatorBloc,
    this._routerBloc,
  ) {
    onTodoSaved.connect().addTo(_compositeSubscription);

    _$fetchTodoEvent
        .startWith(null)
        .mapTo(_id)
        .whereNotNull()
        .switchMap(
          (id) => _listService.fetchTodoById(id, initialTodo).asResultStream(),
        )
        .setResultStateHandler(this)
        .whereSuccess()
        .bind(_todoSubject)
        .addTo(_compositeSubscription);
  }

  final TodoManageService _todoManageService;
  final TodoListService _listService;
  final TodoValidatorService _validatorService;
  final CoordinatorBlocType _coordinatorBloc;
  final RouterBlocType _routerBloc;

  /// The id of the todo.
  /// If the id is not null, the todo is being edited otherwise it is being created.
  final String? _id;

  final _todoSubject = BehaviorSubject<TodoModel>.seeded(TodoModel.empty());

  @override
  Stream<String> _mapToDescriptionState() => Rx.combineLatest2(
          _$setDescriptionEvent.startWith(null),
          _todoSubject,
          (description, todo) => description ?? todo.description)
      .shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToTitleState() => Rx.combineLatest2(
        _$setTitleEvent.cast<String?>().startWith(null),
        _todoSubject,
        (title, todo) => title ?? todo.title,
      )
          .map((title) => _validatorService.validateTitle(title))
          .shareReplay(maxSize: 1);

  @override
  ConnectableStream<TodoModel> _mapToOnTodoSavedState() => _$saveEvent
      .withLatestFrom(
          Rx.combineLatest3<String, String, TodoModel?, TodoModel?>(
            title,
            description,
            _todoSubject,
            (title, description, todo) => TodoModel.from(
              title: title,
              description: description,
              todo: todo,
            ),
          ).onErrorReturn(null),
          (_, todo) => todo)
      .whereNotNull()
      .switchMap(
        (todo) => _todoManageService.addOrUpdate(todo).asResultStream(),
      )
      .setResultStateHandler(this)
      .doOnData(_coordinatorBloc.events.todoAddedOrUpdated)
      .whereSuccess()
      .doOnData((todo) => _routerBloc.events.go(const TodoListRoute()))
      .publish();

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<bool> _mapToShowErrorState() =>
      _$saveEvent.mapTo(true).startWith(false);

  @override
  bool get isEditingTodo => _id != null;

  @override
  void dispose() {
    _todoSubject.close();
    super.dispose();
  }
}
