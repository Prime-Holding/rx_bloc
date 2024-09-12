import 'dart:async';

import 'package:realm/realm.dart';

import '../../models/errors/error_model.dart';
import '../../models/todo_model.dart';

class TodoLocalDataSource {
  final Realm _realmInstance;
  TodoLocalDataSource(this._realmInstance);

  Stream<List<$TodoModel>> allTodos() => _realmInstance
      .all<TodoModel>()
      .query(r'action != $0 SORT(createdAt DESC)', ['delete'])
      .changes
      .map((element) => element.results.toList());

  void addMany(List<$TodoModel> todos) {
    if (todos.isEmpty) return;
    _realmInstance.write(() {
      _realmInstance.addAll<TodoModel>(todos as List<TodoModel>);
    });
  }

  void deleteMany(List<$TodoModel> todos) {
    _realmInstance.write(() {
      _realmInstance.deleteMany(todos as List<TodoModel>);
    });
  }

  $TodoModel addTodo($TodoModel todo) {
    _realmInstance.write(() {
      _realmInstance.add<TodoModel>(todo as TodoModel);
    });
    return todo;
  }

  List<$TodoModel> fetchAllUnsyncedTodos() {
    final results = _realmInstance.query<TodoModel>(r'synced == $0', [false]);
    return results.map((element) => element).toList();
  }

  List<$TodoModel> fetchAllTodos() {
    final results =
        _realmInstance.query<TodoModel>(r'action != $0', ['delete']);
    return results.map((element) => element).toList();
  }

  $TodoModel updateTodoById(String id, $TodoModel todo) {
    final result = _realmInstance.find<TodoModel>(id);

    if (result == null) {
      throw NotFoundErrorModel(message: 'Todo with id $id not found');
    }
    _realmInstance.write(() {
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
    final todo = _realmInstance.find<TodoModel>(id);

    if (todo == null) {
      throw NotFoundErrorModel(message: 'Todo with id $id not found');
    }
    _realmInstance.write(() {
      todo.completed = completed;
      todo.synced = synced;
      todo.action = action ?? TodoModelActions.none.name;
    });
    return todo;
  }

  List<$TodoModel> updateCompletedForAll(
    bool completed, {
    bool synced = true,
    String? action,
  }) {
    ///r'action != $0', ['delete']
    final results = _realmInstance
        .all<TodoModel>()
        .query(r'action != $0 AND completed != $1', ['delete', completed]);
    final todos = results.toList();
    _realmInstance.write(() {
      for (var todo in todos) {
        todo.completed = completed;
        todo.action = action ?? TodoModelActions.none.name;
        todo.synced = synced;
      }
    });
    return todos.map((element) => element).toList();
  }

  List<TodoModel> softDeleteCompleted({bool synced = true, String? action}) {
    final results = _realmInstance.all<TodoModel>().query('completed == true');
    final todos = results.toList();
    _realmInstance.write(() {
      for (var todo in todos) {
        ///Instead of deleting the todo, we will mark it for deletion
        todo.action = action ?? TodoModelActions.none.name;
        todo.synced = synced;
      }
    });
    return todos;
  }

  List<$TodoModel> deleteCompleted({bool synced = true, String? action}) {
    final results = _realmInstance.all<TodoModel>().query('completed == true');
    final todos = results.toList();
    _realmInstance.write(() {
      for (var todo in todos) {
        _realmInstance.delete<TodoModel>(todo);
      }
    });
    return todos;
  }

  void deleteTodoById(
    String id, {
    bool synced = true,
    String? action,
  }) {
    final todo = _realmInstance.find<TodoModel>(id);

    if (todo == null) {
      throw NotFoundErrorModel(message: 'Todo with id $id not found');
    }
    if (todo.isValid) {
      _realmInstance.write(() {
        _realmInstance.delete<TodoModel>(todo);
      });
    }
  }

  void softDeleteTodoById(
    String id, {
    bool synced = true,
    String? action,
  }) {
    final todo = _realmInstance.find<TodoModel>(id);

    if (todo == null) {
      throw NotFoundErrorModel(message: 'Todo with id $id not found');
    }

    ///Instead of deleting the todo, we will mark it for deletion
    _realmInstance.write(() {
      todo.action = action ?? TodoModelActions.delete.name;
      todo.synced = synced;
    });
  }

  $TodoModel getTodoById(String id) {
    final todo = _realmInstance.find<TodoModel>(id);

    if (todo == null) {
      throw NotFoundErrorModel(message: 'Todo with id $id not found');
    }

    return todo.freeze();
  }
}
