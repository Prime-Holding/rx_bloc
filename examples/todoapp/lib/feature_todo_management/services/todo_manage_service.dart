import '../../base/models/todo_model.dart';
import '../../base/repositories/todo_rest_repository.dart';

class TodoManageService {
  TodoManageService(this._repository);

  final TodoRestRepository _repository;

  /// Adds or updates a todo.
  ///
  /// If the [todo] has an [id], it will be updated. Otherwise, it will be added.
  Future<TodoModel> addOrUpdate(TodoModel todo) async {
    if (todo.id == null) {
      return _repository.addTodo(todo);
    } else {
      return _repository.updateTodoById(todo.id!, todo);
    }
  }
}
