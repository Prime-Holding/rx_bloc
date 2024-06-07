import '../../base/models/todo_model.dart';
import '../../base/repositories/todo_list_repository.dart';

class TodoManageService {
  TodoManageService(this._repository);

  final TodoListRepository _repository;

  /// Adds or updates a todo.
  ///
  /// If the [todo] has an [id], it will be updated. Otherwise, it will be added.
  Future<TodoModel> addOrUpdate(TodoModel todo) =>
      _repository.addOrUpdate(todo: todo);
}
