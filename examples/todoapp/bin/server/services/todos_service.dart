import 'package:todoapp/base/models/todo_model.dart';

import '../repositories/todos_repository.dart';

class TodosService {
  final TodosRepository todoRepository;
  TodosService(this.todoRepository);

  // Sync all todos to the repository

  List<$TodoModel> syncAllTodos(List<$TodoModel> todos) =>
      todoRepository.syncAllTodos(todos);

  // Fetches all todos from the repository
  List<$TodoModel> fetchAllTodos() => todoRepository.fetchAllTodos();

  // Add a new todo to the repository
  $TodoModel addTodo($TodoModel todo) => todoRepository.addTodo(todo);

  // Update a todo by its id in the repository
  $TodoModel updateTodoById($TodoModel todo) =>
      todoRepository.updateTodoById(todo);

  // Update the completed status of a todo by its id in the repository
  $TodoModel updateCompletedById(String id, bool completed) =>
      todoRepository.updateCompletedById(id, completed);

  // Update the completed status of all todos to true or false in the repository
  List<$TodoModel> updateCompletedForAll(bool completed) =>
      todoRepository.updateCompletedForAll(completed);

  // Delete all completed todos from the repository
  List<$TodoModel> deleteCompleted() => todoRepository.deleteCompleted();

  // Delete a todo by its id from the repository
  void deleteById(String id) => todoRepository.deleteById(id);

  // Fetch a todo by its id from the repository
  $TodoModel fetchTodoById(String id) => todoRepository.fetchTodoById(id);
}
