import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/remote/todos_remote_data_source.dart';
import '../models/todo_model.dart';
import 'todo_repository.dart';

class TodoRestRepository implements TodoRepository {
  TodoRestRepository(this._errorMapper, this.dataSource);

  final ErrorMapper _errorMapper;
  final TodosRemoteDataSource dataSource;

  @override
  Future<List<TodoModel>> fetchAllTodos() => _errorMapper.execute(
        () => dataSource.getAllTodos(),
      );

  @override
  Future<TodoModel> addTodo(TodoModel todo) => _errorMapper.execute(
        () => dataSource.addTodo(todo),
      );

  @override
  Future<TodoModel> updateTodoById(String id, TodoModel todo) =>
      _errorMapper.execute(
        () => dataSource.updateTodoById(id, todo),
      );

  @override
  Future<TodoModel> updateCompletedById(String id, bool completed) =>
      _errorMapper.execute(
        () => dataSource.updateCompletedById(id, {'completed': completed}),
      );

  @override
  Future<List<TodoModel>> updateCompletedForAll(bool completed) =>
      _errorMapper.execute(
        () => dataSource.updateCompletedForAll({'completed': completed}),
      );

  @override
  Future<List<TodoModel>> deleteCompleted() => _errorMapper.execute(
        () => dataSource.deleteCompleted(),
      );

  @override
  Future<void> deleteTodoById(String id) => _errorMapper.execute(
        () => dataSource.deleteTodoById(id),
      );

  @override
  Future<TodoModel> fetchTodoById(String id) => _errorMapper.execute(
        () => dataSource.getTodoById(id),
      );
}
