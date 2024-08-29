import '../models/todo_model.dart';
import '../models/todos_filter_model.dart';
import '../repositories/todo_repository.dart';

class TodoListService {
  TodoListService(this._repository);

  final TodoRepository _repository;

  /// Fetches all todos.
  ///
  /// The todos are sorted by their creation date.
  Stream<List<$TodoModel>> fetchTodoList() {
    return _repository.fetchAllTodos();
  }

  /// Fetches a todo by its [id].
  ///
  /// If the [todo] is not null, it will be returned for lazy-loading purposes.
  /// Otherwise, the todo will be fetched from the repository.
  Stream<$TodoModel> fetchTodoById(String id, [$TodoModel? todo]) async* {
    if (todo != null && todo.id == id) {
      yield todo;
    }

    yield await _repository.fetchTodoById(id);
  }

  /// Filters the [todos] based on the [filter].
  ///
  /// Returns a list of the filtered todos.
  /// If the [filter] is [TodosFilterModel.all], all todos will be returned.
  /// If the [filter] is [TodosFilterModel.incomplete], only the incomplete todos will be returned.
  /// If the [filter] is [TodosFilterModel.completed], only the completed todos will be returned.
  List<$TodoModel> filterTodos(
      List<$TodoModel> todos, TodosFilterModel filter) {
    switch (filter) {
      case TodosFilterModel.all:
        return todos;
      case TodosFilterModel.incomplete:
        return todos.where((todo) => !todo.completed).toList();
      case TodosFilterModel.completed:
        return todos.where((todo) => todo.completed).toList();
    }
  }
}
