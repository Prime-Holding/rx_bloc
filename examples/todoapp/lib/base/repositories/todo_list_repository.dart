// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/local/todo_list_local_data_source.dart';
import '../models/todo_model.dart';

class TodoListRepository {
  TodoListRepository(
    this._errorMapper,
    this._localDataSource,
  );

  final ErrorMapper _errorMapper;
  final TodoListDataSource _localDataSource;

  Future<List<TodoModel>> fetchAllTodos() => _errorMapper.execute(
        () => _localDataSource.fetchAllTodos(),
      );

  Future<TodoModel> addOrUpdate({
    required TodoModel todo,
  }) =>
      _errorMapper.execute(
        () => _localDataSource.addOrUpdateTodo(todo),
      );

  Future<TodoModel> updateCompletedById(String id, bool completed) =>
      _errorMapper.execute(
        () => _localDataSource.updateCompletedById(id, completed),
      );

  Future<List<TodoModel>> updateCompletedForAll(bool completed) => _errorMapper.execute(
        () => _localDataSource.updateCompletedForAll(completed),
      );

  Future<List<TodoModel>> deleteCompleted() => _errorMapper.execute(
        () => _localDataSource.deleteCompleted(),
      );

  Future<void> deleteById(String id) => _errorMapper.execute(
        () => _localDataSource.deleteById(id),
      );

  Future<TodoModel> fetchTodoById(String id) => _errorMapper.execute(
        () => _localDataSource.fetchTodoById(id),
      );
}
