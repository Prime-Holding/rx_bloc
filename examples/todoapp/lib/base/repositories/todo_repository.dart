import 'dart:async';

import 'package:realm/realm.dart' show Uuid;
import 'package:rxdart/rxdart.dart';
import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/local/connectivity_data_source.dart';
import '../data_sources/local/todo_local_data_source.dart';
import '../data_sources/remote/todos_remote_data_source.dart';
import '../models/errors/error_model.dart';
import '../models/todo_model.dart';

class TodoRepository {
  TodoRepository(
    this._errorMapper,
    this.dataSource,
    this.localDataSource,
    this.connectivityDataSource,
  ) {
    _connectivitySubscription =
        connectivityDataSource.connected().listen((event) {
      if (event) {
        syncronize();
      } else {
        localDataSource.pauseSync();
      }
    });
  }

  final ErrorMapper _errorMapper;
  final TodosRemoteDataSource dataSource;
  final TodoLocalDataSource localDataSource;
  final ConnectivityDataSource connectivityDataSource;
  StreamSubscription<bool>? _connectivitySubscription;

  Stream<List<$TodoModel>> fetchAllTodos() => Rx.combineLatest2(
          _errorMapper.executeStream(localDataSource.allTodos()),
          _errorMapper.execute(() => dataSource.getAllTodos()).asStream(),
          (List<$TodoModel> local, List<$TodoModel> remote) {
        final List<$TodoModel> missingTodos = remote
            .where((remoteTodo) =>
                !local.any((localTodo) => localTodo.id == remoteTodo.id))
            .toList();

        localDataSource.addMany(missingTodos);
        return local;
      });

  Future<$TodoModel> addTodo($TodoModel todo) => _errorMapper.execute(
        () async {
          final result = await dataSource.addTodo(todo);
          localDataSource.addTodo(result);
          return result;
        },
      ).onError(
        (error, stackTrace) => handleError(
          error,
          localDataSource.addTodo(
            todo.copyWith(
              id: Uuid.v4().toString(),
              synced: false,
              action: TodoModelActions.add.name,
            ),
          ),
        ),
      );

  Future<$TodoModel> updateTodoById(String id, $TodoModel todo) =>
      _errorMapper.execute(
        () async {
          final result = await dataSource.updateTodoById(id, todo);
          localDataSource.updateTodoById(id, todo);
          return result;
        },
      ).onError(
        (error, stackTrace) => handleError(
          error,
          localDataSource.updateTodoById(
            id,
            todo.copyWith(
              synced: false,
              action: TodoModelActions.update.name,
            ),
          ),
        ),
      );

  Future<$TodoModel> updateCompletedById(String id, bool completed) =>
      _errorMapper.execute(
        () async {
          final result = await dataSource
              .updateCompletedById(id, {'completed': completed});
          localDataSource.updateCompletedById(
            id,
            completed,
          );
          return result;
        },
      ).onError(
        (error, stackTrace) => handleError(
          error,
          localDataSource.updateCompletedById(
            id,
            completed,
            synced: false,
            action: TodoModelActions.update.name,
          ),
        ),
      );

  Future<List<$TodoModel>> updateCompletedForAll(bool completed) =>
      _errorMapper.execute(
        () async {
          final result =
              await dataSource.updateCompletedForAll({'completed': completed});
          localDataSource.updateCompletedForAll(completed);
          return result;
        },
      ).onError(
        (error, stackTrace) => handleError(
          error,
          localDataSource.updateCompletedForAll(
            completed,
            synced: false,
            action: TodoModelActions.update.name,
          ),
        ),
      );

  Future<List<$TodoModel>> deleteCompleted() => _errorMapper.execute(
        () async {
          final response = await dataSource.deleteCompleted();
          localDataSource.deleteCompleted();
          return response;
        },
      ).onError(
        (error, stackTrace) => handleError(
          error,
          localDataSource.softDeleteCompleted(
            synced: false,
            action: TodoModelActions.delete.name,
          ),
        ),
      );

  Future<void> deleteTodoById(String id) => _errorMapper.execute(
        () async {
          await dataSource.deleteTodoById(id);
          localDataSource.deleteTodoById(id);
        },
      ).onError((error, stackTrace) {
        if (error is NoConnectionErrorModel) {
          localDataSource.softDeleteTodoById(
            id,
            synced: false,
            action: TodoModelActions.delete.name,
          );
          return;
        }
        if (error is ErrorModel) {
          throw error;
        } else {
          throw UnknownErrorModel();
        }
      });

  Future<$TodoModel> fetchTodoById(String id) => _errorMapper.execute(
        () async {
          final result = await dataSource.getTodoById(id);
          return result;
        },
      ).onError((error, stackTrace) => handleError(
            error,
            localDataSource.getTodoById(id),
          ));

  Future<void> syncronize() async {
    final List<TodoModel> unsyncedTodos =
        localDataSource.fetchAllUnsyncedTodos();

    if (unsyncedTodos.isNotEmpty) {
      await _errorMapper.execute(
        () async {
          localDataSource.unpauseSync();
          final result = await dataSource.syncTodos({'todos': unsyncedTodos});
          localDataSource.deleteMany(unsyncedTodos);
          localDataSource.addMany(result);
        },
      );
    }
  }

  T handleError<T>(
    Object? error,
    T function,
  ) {
    if (error is NoConnectionErrorModel) {
      return function;
    }
    if (error is ErrorModel) {
      throw error;
    } else {
      throw UnknownErrorModel();
    }
  }

  void dispose() {
    if (_connectivitySubscription != null) {
      _connectivitySubscription?.cancel();
    }
  }
}
