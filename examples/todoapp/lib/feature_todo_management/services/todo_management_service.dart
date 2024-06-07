import '../../base/models/todo_model.dart';
import '../../base/repositories/todo_list_repository.dart';

class TodoManagementService {
  TodoManagementService(this._repository);

  final TodoListRepository _repository;

  Future<TodoModel> addOrUpdate(TodoModel todoModel) =>
      _repository.addOrUpdate(todo: todoModel);

  Future<TodoModel> fetchTodoById(String id) =>
      _repository.fetchTodoById(id);
}
