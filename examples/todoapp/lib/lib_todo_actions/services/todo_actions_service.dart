import '../../base/models/todo_model.dart';
import '../../base/repositories/todo_rest_repository.dart';

class TodoActionsService {
  TodoActionsService(this._repository);

  final TodoRestRepository _repository;

  /// Deletes the todo by its [id].
  ///
  /// Throws a [NotFoundErrorModel] if the todo does not exist.
  Future<TodoModel> deleteTodoById(String id) async {
    final todo = await _repository.fetchTodoById(id);
    return await _repository.deleteTodoById(id).then((_) => todo);
  }

  /// Checks if all todos are completed.
  ///
  /// Returns true if all todos are completed.
  bool areAllCompleted(List<TodoModel> todos) =>
      todos.every((todo) => todo.completed);

  /// Checks if all todos are incomplete.
  ///
  /// Returns true if all todos are incomplete.
  bool areAllIncomplete(List<TodoModel> todos) =>
      todos.every((todo) => !todo.completed);

  /// Checks if any todo is completed.
  ///
  /// Returns true if any todo is completed.
  bool hasCompleted(List<TodoModel> todos) =>
      todos.any((todo) => todo.completed);

  /// Updates the [completed] status for all todos.
  ///
  /// If [completed] is true, all todos will be marked as completed.
  Future<List<TodoModel>> updateCompletedForAll({required bool completed}) =>
      _repository.updateCompletedForAll(completed);

  /// Updates the [completed] status for a todo by its [id].
  ///
  /// Throws a [NotFoundErrorModel] if the todo does not exist.
  Future<TodoModel> updateCompletedById(String id, bool completed) =>
      _repository.updateCompletedById(id, completed);

  /// Deletes all completed todos.
  ///
  /// Returns a list of the deleted todos.
  Future<List<TodoModel>> deleteCompleted() => _repository.deleteCompleted();
}
