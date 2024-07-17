// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:collection/collection.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:uuid/uuid.dart';

import '../models/todo_model_list.dart';

class TodosRepository {
  TodosRepository(this.uuid);

  final Uuid uuid;

  final List<TodoModel> _todos = [];

  TodoModelList fetchAllTodos() => TodoModelList(todos: _todos);

  TodoModel addTodo(String title, String? description) {
    // final index = _todos.indexWhere((element) => element.id == todo.id);
    final todo = TodoModel.from(title: title, description: description ?? '');
    _todos.insert(0, todo);
    return todo;
  }

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

  TodoModel updateCompletedById(String id, ) {
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

  TodoModelList updateCompletedForAll(bool completed) {
    if (_todos.isNotEmpty) {
      _todos.forEachIndexed(
          (index, todo) => _todos[index] = todo.copyWith(completed: completed));
      return TodoModelList(todos: _todos);
    }

    throw Exception('No todos in the local data storage!');
  }

  TodoModelList deleteCompleted() {
    var listJson = _todos;
    if (listJson.isNotEmpty) {
      _todos.removeWhere((element) => element.completed == true);

      if (_todos.isEmpty) {
      } else {}

      return TodoModelList(todos: _todos);
    }

    throw Exception('No _todos in the local data storage!');
  }

  void deleteById(String id) {
    if (_todos.isNotEmpty) {
      for (var element in _todos) {
        if (element.id != null && element.id == id) {
          _todos.remove(element);
          break;
        }
      }
    }
  }

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
