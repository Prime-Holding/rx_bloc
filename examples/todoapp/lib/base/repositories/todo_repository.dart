import 'dart:async';

import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/local/todo_local_data_source.dart';
import '../data_sources/remote/todos_remote_data_source.dart';
import '../models/todo_model.dart';
import '../utils/no_connection_handle_mixin.dart';

class TodoRepository with NoConnectionHandlerMixin {
  TodoRepository(
    this._errorMapper,
    this.dataSource,
    this.localDataSource,
  );

  final ErrorMapper _errorMapper;
  final TodosRemoteDataSource dataSource;
  final TodoLocalDataSource localDataSource;

  Stream<List<$TodoModel>> fetchAllTodos() =>
      _errorMapper.executeStream(localDataSource.allTodos());

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
      ).onError(
        (error, stackTrace) {
          handleError(
            error,
            localDataSource.softDeleteTodoById(
              id,
              synced: false,
              action: TodoModelActions.delete.name,
            ),
          );
        },
      );

  Future<$TodoModel> fetchTodoById(String id) => _errorMapper.execute(
        () async => localDataSource.getTodoById(id),
      );

  Future<List<$TodoModel>> fetchAllUnsyncedTodos() => _errorMapper.execute(
        () async => localDataSource.fetchAllUnsyncedTodos(),
      );
  Future<List<$TodoModel>> syncTodos(Map<String, List<$TodoModel>> todos) =>
      _errorMapper.execute(
        () async => dataSource.syncTodos(todos),
      );

  void unpauseRealmSync() => localDataSource.unpauseSync();

  void pauseRealmSync() => localDataSource.pauseSync();

  void deleteMany(List<$TodoModel> todos) => localDataSource.deleteMany(todos);

  void addMany(List<$TodoModel> todos) => localDataSource.addMany(todos);
}
