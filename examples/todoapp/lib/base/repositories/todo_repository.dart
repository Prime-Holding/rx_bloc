import '../models/todo_model.dart';

abstract class TodoRepository {
  Future<List<TodoModel>> fetchAllTodos();

  Future<TodoModel> addTodo(TodoModel todo);

  Future<TodoModel> updateTodoById(String id, TodoModel todo);

  Future<TodoModel> updateCompletedById(String id, bool completed);

  Future<List<TodoModel>> updateCompletedForAll(bool completed);

  Future<List<TodoModel>> deleteCompleted();

  Future<void> deleteTodoById(String id);

  Future<TodoModel> fetchTodoById(String id);
}
