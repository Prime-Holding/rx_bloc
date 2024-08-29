// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:collection/collection.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:uuid/uuid.dart';

class TodosRepository {
  TodosRepository(this._uuid);

  final Uuid _uuid;
  // The list of todos
  final List<$TodoModel> _todos = [];

  // Fetches all todos from the list of todos
  List<$TodoModel> fetchAllTodos() => _todos;

  //Sync the list of todos with the provided list

  List<$TodoModel> syncAllTodos(List<$TodoModel> todos) {
    final List<$TodoModel> responseList = [];
    for (final todo in todos) {
      switch (todo.action) {
        case 'delete':
          deleteById(todo.id!);
          break;
        case 'update':
          final index =
              _todos.firstWhereOrNull((element) => element.id == todo.id);
          if (index?.id == null) {
            final newTodo = addTodo(todo);
            responseList.add(newTodo);
          } else {
            final newTodo = updateTodoById(todo);
            responseList.add(newTodo);
          }
          break;
        case 'add':
          final newTodo = addTodo(todo);
          responseList.add(newTodo);
          break;
      }
    }
    return responseList;
  }

  // Add a new todo to the list of todos
  $TodoModel addTodo($TodoModel todo) {
    final newTodo = TodoModel(
      _uuid.v4(),
      todo.title,
      todo.description,
      todo.completed,
      DateTime.now().millisecondsSinceEpoch,
      synced: true,
      action: TodoModelActions.none.name,
    );
    _todos.insert(0, newTodo);
    return newTodo;
  }

  // Update a todo by its id
  $TodoModel updateTodoById($TodoModel todo) {
    if (_todos.isNotEmpty) {
      final updateTodo = _todos.firstWhere((element) => element.id == todo.id);
      if (updateTodo.id != null) {
        updateTodo.action = TodoModelActions.none.name;
        updateTodo.title = todo.title;
        updateTodo.description = todo.description;
        updateTodo.completed = todo.completed;
        updateTodo.synced = true;

        return updateTodo;
      }
    }

    throw Exception(
        'Unable to update Todo, because todo with id  = $todo.id cannot be found!');
  }

  // Update the completed status of a todo by its id
  $TodoModel updateCompletedById(
    String id,
    bool completed,
  ) {
    if (_todos.isNotEmpty) {
      final index = _todos.indexWhere((element) => element.id == id);
      if (index >= 0) {
        _todos[index] = _todos[index].copyWith(
          completed: completed,
          action: TodoModelActions.none.name,
        );

        return _todos[index];
      }
    }

    throw Exception(
        'Unable to update Todo, because todo with id  = $id cannot be found!');
  }

  // Update the completed status of all todos to true or false
  List<$TodoModel> updateCompletedForAll(bool completed) {
    if (_todos.isNotEmpty) {
      _todos.forEachIndexed((index, todo) => _todos[index] = todo.copyWith(
            completed: completed,
            action: TodoModelActions.none.name,
          ));
      return _todos;
    }

    throw Exception('No todos in the local data storage!');
  }

  // Delete all completed todos
  List<$TodoModel> deleteCompleted() {
    var listJson = _todos;
    if (listJson.isNotEmpty) {
      _todos.removeWhere((element) => element.completed == true);

      return _todos;
    }

    throw Exception('No _todos in the local data storage!');
  }

  // Delete a todo by its id
  void deleteById(String id) {
    if (_todos.isNotEmpty) {
      _todos.removeWhere((element) => element.id == id);
    }
  }

  // Fetch a single todo by its id
  $TodoModel fetchTodoById(String id) {
    $TodoModel? result;

    if (_todos.isNotEmpty) {
      result = _todos.firstWhereOrNull((element) => element.id == id);
    }

    if (result == null) {
      throw Exception('No todo found with id $id in the local data storage!');
    } else {
      return result;
    }
  }
}
