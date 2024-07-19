import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/remote/todos_remote_data_source.dart';
import '../models/todo_model.dart';

class TodoRepository {
  TodoRepository(this._errorMapper, this.dataSource);

  final ErrorMapper _errorMapper;
  final TodosRemoteDataSource dataSource;

  Future<List<TodoModel>> fetchAllTodos() => _errorMapper.execute(
        () => dataSource.getAllTodos(),
      );

  Future<TodoModel> addTodo(TodoModel todo) => _errorMapper.execute(
        () => dataSource.addTodo(todo),
      );

  Future<TodoModel> updateTodoById(String id, TodoModel todo) =>
      _errorMapper.execute(
        () => dataSource.updateTodoById(id, todo),
      );

  Future<TodoModel> updateCompletedById(String id, bool completed) =>
      _errorMapper.execute(
        () => dataSource.updateCompletedById(id, {'completed': completed}),
      );

  Future<List<TodoModel>> updateCompletedForAll(bool completed) =>
      _errorMapper.execute(
        () => dataSource.updateCompletedForAll({'completed': completed}),
      );

  Future<List<TodoModel>> deleteCompleted() => _errorMapper.execute(
        () => dataSource.deleteCompleted(),
      );

  Future<void> deleteTodoById(String id) => _errorMapper.execute(
        () => dataSource.deleteTodoById(id),
      );

  Future<TodoModel> fetchTodoById(String id) => _errorMapper.execute(
        () => dataSource.getTodoById(id),
      );
}
