import '../extensions/todo_list_extensions.dart';
import '../models/todo_model.dart';
import '../models/todos_filter_model.dart';
import '../repositories/todo_list_repository.dart';

class TodoListService {
  TodoListService(this._repository);

  final TodoListRepository _repository;

  Future<List<TodoModel>> fetchTodoList() => _repository.fetchAllTodos().then(
        (list) => list.sortByCreatedAt(),
      );

  Future<List<TodoModel>> updateCompletedForAll({required bool completed}) =>
      _repository.updateCompletedForAll(completed);

  Future<TodoModel> updateCompletedById(String id, bool completed) =>
      _repository.updateCompletedById(id, completed);

  Future<List<TodoModel>> deleteCompleted() => _repository.deleteCompleted();

  /// Fetches a todo by its [id].
  ///
  /// If the [todo] is not null, it will be returned.
  Future<TodoModel> fetchTodoById(String id, [TodoModel? todo]) async {
    if (todo != null) {
      return todo;
    }

    return fetchTodoById(id);
  }

  List<TodoModel> filterTodos(List<TodoModel> todos, TodosFilterModel filter) {
    switch (filter) {
      case TodosFilterModel.all:
        return todos;
      case TodosFilterModel.incomplete:
        return todos.where((todo) => !todo.completed).toList();
      case TodosFilterModel.completed:
        return todos.where((todo) => todo.completed).toList();
    }
  }

  bool areAllCompleted(List<TodoModel> todos) =>
      todos.every((todo) => todo.completed);

  bool areAllIncomplete(List<TodoModel> todos) =>
      todos.every((todo) => !todo.completed);

  bool hasCompleted(List<TodoModel> todos) =>
      todos.any((todo) => todo.completed);
}
