import 'dart:async';

import '../models/todo_model.dart';
import '../models/todos_filter_model.dart';
import '../repositories/connectivity_repository.dart';
import '../repositories/todo_repository.dart';

class TodoListService {
  TodoListService(
    this._repository,
    this._connectivityRepository,
  ) {
    _connectivitySubscription =
        _connectivityRepository.connected().listen((event) {
      if (event) {
        synchronizeTodos();
      }
    });
  }

  final TodoRepository _repository;
  final ConnectivityRepository _connectivityRepository;
  StreamSubscription<bool>? _connectivitySubscription;

  /// Synchronizes the todos.
  ///
  /// Fetches all unsynced todos and syncs them with the server.
  Future<void> synchronizeTodos() async {
    final List<$TodoModel> unsyncedTodos =
        await _repository.fetchAllUnsyncedTodos();
    if (unsyncedTodos.isNotEmpty) {
      final result = await _repository.syncTodos({'todos': unsyncedTodos});
      _repository.deleteMany(unsyncedTodos);
      _repository.addMany(result);
    }
  }

  /// Fetches all todos.
  ///
  /// The todos are sorted by their creation date.
  Stream<List<$TodoModel>> fetchTodoList() {
    return _repository.fetchAllTodos();
  }

  /// Fetches a todo by its [id].
  ///
  /// If the [todo] is not null, it will be returned for lazy-loading purposes.
  /// Otherwise, the todo will be fetched from the repository.
  Stream<$TodoModel> fetchTodoById(String id, [$TodoModel? todo]) async* {
    if (todo != null && todo.id == id) {
      yield todo;
    }

    yield await _repository.fetchTodoById(id);
  }

  /// Filters the [todos] based on the [filter].
  ///
  /// Returns a list of the filtered todos.
  /// If the [filter] is [TodosFilterModel.all], all todos will be returned.
  /// If the [filter] is [TodosFilterModel.incomplete], only the incomplete todos will be returned.
  /// If the [filter] is [TodosFilterModel.completed], only the completed todos will be returned.
  List<$TodoModel> filterTodos(
      List<$TodoModel> todos, TodosFilterModel filter) {
    switch (filter) {
      case TodosFilterModel.all:
        return todos;
      case TodosFilterModel.incomplete:
        return todos.where((todo) => !todo.completed).toList();
      case TodosFilterModel.completed:
        return todos.where((todo) => todo.completed).toList();
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
