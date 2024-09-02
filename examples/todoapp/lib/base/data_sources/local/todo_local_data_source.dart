import 'package:realm/realm.dart';
import '../../models/errors/error_model.dart';
import '../../models/todo_model.dart';

class TodoLocalDataSource {
  final Realm _realm;
  TodoLocalDataSource(this._realm);

  Stream<List<$TodoModel>> allTodos() => _realm
      .all<TodoModel>()
      .query(r'action != $0 SORT(createdAt DESC)', ['delete'])
      .changes
      .map((element) => element.results.toList());

  void pauseSync() => _realm.syncSession.pause();

  void unpauseSync() => _realm.syncSession.resume();

  void addMany(List<$TodoModel> todos) {
    if (todos.isEmpty) return;
    _realm.write(() {
      _realm.addAll<TodoModel>(todos as List<TodoModel>);
    });
  }

  void deleteMany(List<$TodoModel> todos) {
    _realm.write(() {
      _realm.deleteMany(todos as List<TodoModel>);
    });
  }

  $TodoModel addTodo($TodoModel todo) {
    _realm.write(() {
      _realm.add<TodoModel>(todo as TodoModel);
    });
    return todo;
  }

  List<TodoModel> fetchAllUnsyncedTodos() {
    final results = _realm.query<TodoModel>(r'synced == $0', [false]);
    return results.map((element) => element).toList();
  }

  List<TodoModel> fetchAllTodos() {
    final results = _realm.query<TodoModel>(r'action != $0', ['delete']);
    return results.map((element) => element).toList();
  }

  $TodoModel updateTodoById(String id, $TodoModel todo) {
    final result = _realm.find<TodoModel>(id);

    if (result == null) {
      throw NotFoundErrorModel(message: 'Todo with id $id not found');
    }
    _realm.write(() {
      result.title = todo.title;
      result.description = todo.description;
      result.completed = todo.completed;
      result.synced = todo.synced;
      result.action = todo.action;
    });
    return result;
  }

  TodoModel updateCompletedById(
    String id,
    bool completed, {
    bool synced = true,
    String? action,
  }) {
    final todo = _realm.find<TodoModel>(id);

    if (todo == null) {
      throw NotFoundErrorModel(message: 'Todo with id $id not found');
    }
    _realm.write(() {
      todo.completed = completed;
      todo.synced = synced;
      todo.action = action ?? TodoModelActions.none.name;
    });
    return todo;
  }

  List<TodoModel> updateCompletedForAll(
    bool completed, {
    bool synced = true,
    String? action,
  }) {
    final results = _realm.all<TodoModel>().query('completed != $completed');
    final todos = results.toList();
    _realm.write(() {
      for (var todo in todos) {
        todo.completed = completed;
        todo.action = action ?? TodoModelActions.none.name;
        todo.synced = synced;
      }
    });
    return todos.map((element) => element).toList();
  }

  List<TodoModel> softDeleteCompleted({bool synced = true, String? action}) {
    final results = _realm.all<TodoModel>().query('completed == true');
    final todos = results.toList();
    _realm.write(() {
      for (var todo in todos) {
        ///Instead of deleting the todo, we will mark it for deletion
        todo.action = action ?? TodoModelActions.none.name;
        todo.synced = synced;
      }
    });
    return todos;
  }

  List<TodoModel> deleteCompleted({bool synced = true, String? action}) {
    final results = _realm.all<TodoModel>().query('completed == true');
    final todos = results.toList();
    _realm.write(() {
      for (var todo in todos) {
        _realm.delete<TodoModel>(todo);
      }
    });
    return todos;
  }

  void deleteTodoById(
    String id, {
    bool synced = true,
    String? action,
  }) {
    final todo = _realm.find<TodoModel>(id);

    if (todo == null) {
      throw NotFoundErrorModel(message: 'Todo with id $id not found');
    }
    if (todo.isValid) {
      _realm.write(() {
        _realm.delete<TodoModel>(todo);
      });
    }
  }

  void softDeleteTodoById(
    String id, {
    bool synced = true,
    String? action,
  }) {
    final todo = _realm.find<TodoModel>(id);

    if (todo == null) {
      throw NotFoundErrorModel(message: 'Todo with id $id not found');
    }

    ///Instead of deleting the todo, we will mark it for deletion
    _realm.write(() {
      todo.action = action ?? TodoModelActions.delete.name;
      todo.synced = synced;
    });
  }

  $TodoModel getTodoById(String id) {
    final todo = _realm.find<TodoModel>(id);

    if (todo == null) {
      throw NotFoundErrorModel(message: 'Todo with id $id not found');
    }

    return todo.freeze();
  }
}
