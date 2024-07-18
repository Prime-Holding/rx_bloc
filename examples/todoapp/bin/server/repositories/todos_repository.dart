// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:collection/collection.dart';
import 'package:todoapp/base/models/todo_model.dart';

import '../models/todo_model_list.dart';

class TodosRepository {
  TodosRepository();

  // The list of todos
  final List<TodoModel> _todos = [];

  // Fetches all todos from the list of todos
  TodoModelList fetchAllTodos() => TodoModelList(todos: _todos);

  // Add a new todo to the list of todos
  TodoModel addTodo(String title, String? description) {
    final todo = TodoModel.from(title: title, description: description ?? '');
    _todos.insert(0, todo);
    return todo;
  }

  // Update a todo by its id
  TodoModel updateTodoById(String id, String title, String? description) {
    if (_todos.isNotEmpty) {
      final index = _todos.indexWhere((element) => element.id == id);
      if (index >= 0) {
        _todos[index] = _todos[index].copyWith(
          title: title,
          description: description,
        );

        return _todos[index];
      }
    }

    throw Exception(
        'Unable to update Todo, because todo with id  = $id cannot be found!');
  }

  // Update the completed status of a todo by its id
  TodoModel updateCompletedById(
    String id,
  ) {
    if (_todos.isNotEmpty) {
      final index = _todos.indexWhere((element) => element.id == id);
      if (index >= 0) {
        _todos[index] =
            _todos[index].copyWith(completed: !_todos[index].completed);

        return _todos[index];
      }
    }

    throw Exception(
        'Unable to update Todo, because todo with id  = $id cannot be found!');
  }

  // Update the completed status of all todos to true or false
  TodoModelList updateCompletedForAll(bool completed) {
    if (_todos.isNotEmpty) {
      _todos.forEachIndexed(
          (index, todo) => _todos[index] = todo.copyWith(completed: completed));
      return TodoModelList(todos: _todos);
    }

    throw Exception('No todos in the local data storage!');
  }

  // Delete all completed todos
  TodoModelList deleteCompleted() {
    var listJson = _todos;
    if (listJson.isNotEmpty) {
      _todos.removeWhere((element) => element.completed == true);

      return TodoModelList(todos: _todos);
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
  TodoModel fetchTodoById(String id) {
    TodoModel? result;

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
