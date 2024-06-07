// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

import '../../models/errors/error_model.dart';
import '../../models/todo_model.dart';
import 'shared_preferences_instance.dart';

/// This class is used to save user profile related settings into shared preferences
/// Currently only notification settings are saved
class TodoListDataSource {
  TodoListDataSource(this._sharedPreferences);

  static const _todoList = 'todoList';

  final SharedPreferencesInstance _sharedPreferences;

  Future<List<TodoModel>> fetchAllTodos() async {
    var listJson = await _sharedPreferences.getString(_todoList);
    List<TodoModel> result = List<TodoModel>.empty(growable: true);

    if (listJson != null && listJson.isNotEmpty) {
      List<dynamic> parsedListJson = jsonDecode(listJson);
      result = List<TodoModel>.from(
          parsedListJson.map<TodoModel>((dynamic i) => TodoModel.fromJson(i)));
    }

    return result;
  }

  Future<TodoModel> addOrUpdateTodo(TodoModel todo) async {
    var listJson = await _sharedPreferences.getString(_todoList);
    List<TodoModel> todos = [];

    if (listJson != null && listJson.isNotEmpty) {
      List<dynamic> parsedListJson = jsonDecode(listJson);
      todos = List<TodoModel>.from(
          parsedListJson.map<TodoModel>((dynamic i) => TodoModel.fromJson(i)));
    }

    final index = todos.indexWhere((element) => element.id == todo.id);

    if (todo.id == null) {
      todo = todo.copyWith(id: UniqueKey().toString());
    }

    if (index >= 0) {
      todos[index] = todo;
    } else {
      todos.insert(0, todo);
    }

    await _sharedPreferences.setString(_todoList, jsonEncode(todos));

    return todo;
  }

  Future<TodoModel> updateCompletedById(String id, bool completed) async {
    var listJson = await _sharedPreferences.getString(_todoList);

    if (listJson != null && listJson.isNotEmpty) {
      List<dynamic> parsedListJson = jsonDecode(listJson);
      var todos = List<TodoModel>.from(
          parsedListJson.map<TodoModel>((dynamic i) => TodoModel.fromJson(i)));

      final index = todos.indexWhere((element) => element.id == id);
      if (index >= 0) {
        todos[index] = todos[index].copyWith(completed: completed);

        await _sharedPreferences.setString(_todoList, jsonEncode(todos));

        return todos[index];
      }
    }

    throw NotFoundErrorModel(
        message:
            'Unable to update Todo, because todo with id  = $id cannot be found!');
  }

  Future<List<TodoModel>> updateCompletedForAll(bool completed) async {
    var listJson = await _sharedPreferences.getString(_todoList);

    if (listJson?.isNotEmpty ?? true) {
      List<dynamic> parsedListJson = jsonDecode(listJson!);
      List<TodoModel> todos = List<TodoModel>.from(
          parsedListJson.map<TodoModel>((dynamic i) => TodoModel.fromJson(i)));

      todos.forEachIndexed(
          (index, todo) => todos[index] = todo.copyWith(completed: completed));

      await _sharedPreferences.setString(_todoList, jsonEncode(todos));

      return todos;
    }

    throw NotFoundErrorModel(message: 'No todos in the local data storage!');
  }

  Future<List<TodoModel>> deleteCompleted() async {
    var listJson = await _sharedPreferences.getString(_todoList);

    if (listJson?.isNotEmpty ?? true) {
      List<dynamic> parsedListJson = jsonDecode(listJson!);
      List<TodoModel> todos = List<TodoModel>.from(
          parsedListJson.map<TodoModel>((dynamic i) => TodoModel.fromJson(i)));

      todos.removeWhere((element) => element.completed == true);

      if (todos.isEmpty) {
        await _sharedPreferences.remove(_todoList);
      } else {
        await _sharedPreferences.setString(_todoList, jsonEncode(todos));
      }

      return todos;
    }

    throw NotFoundErrorModel(message: 'No todos in the local data storage!');
  }

  Future<void> deleteById(String id) async {
    var listJson = await _sharedPreferences.getString(_todoList);

    if (listJson?.isNotEmpty ?? true) {
      List<dynamic> parsedListJson = jsonDecode(listJson!);
      List<TodoModel> todos = List<TodoModel>.from(
          parsedListJson.map<TodoModel>((dynamic i) => TodoModel.fromJson(i)));

      for (var element in todos) {
        if (element.id != null && element.id == id) {
          todos.remove(element);
          break;
        }
      }

      unawaited(_sharedPreferences.setString(_todoList, jsonEncode(todos)));
    }
  }

  Future<TodoModel> fetchTodoById(String id) async {
    var listJson = await _sharedPreferences.getString(_todoList);
    TodoModel? result;

    if (listJson?.isNotEmpty ?? true) {
      List<dynamic> parsedListJson = jsonDecode(listJson!);
      var todos = List<TodoModel>.from(
          parsedListJson.map<TodoModel>((dynamic i) => TodoModel.fromJson(i)));

      result = todos.firstWhereOrNull((element) => element.id == id);
    }

    if (result == null) {
      throw NotFoundErrorModel(
          message: 'No todo found with id $id in the local data storage!');
    } else {
      return result;
    }
  }
}
