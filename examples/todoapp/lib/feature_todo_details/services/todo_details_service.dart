import '../../base/models/errors/error_model.dart';
import '../../base/models/todo_model.dart';
import '../../base/repositories/todo_list_repository.dart';

class TodoDetailsService {
  TodoDetailsService(this._repository);

  final TodoListRepository _repository;

  /// Deletes the todo.
  ///
  /// Throws a [NotFoundErrorModel] if the todo does not exist.
  Future<TodoModel> deleteTodo(TodoModel todo) async {
    if (todo.id != null) {
      return await _repository.deleteById(todo.id!).then((_) => todo);
    }

    throw NotFoundErrorModel();
  }
}
