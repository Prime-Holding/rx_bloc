// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:todoapp/base/models/todo_model.dart';

import '../services/todos_service.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

class TodosController extends ApiController {
  TodosController(this.todosService);

  final TodosService todosService;

  /// Registers all the HTTP request handlers for todo-related operations.
  @override
  void registerRequests(WrappedRouter router) {
    // Handler to get all todos
    router.addRequest(
      RequestType.GET,
      '/api/v1/todos',
      getAllTodosHandler,
    );
    // Handler to add a new todo
    router.addRequest(
      RequestType.POST,
      '/api/v1/todos',
      addTodoHandler,
    );
    // Handler to update a todo by its ID
    router.addRequest(
      RequestType.PUT,
      '/api/v1/todos/<id>',
      updateTodoByIdHandler,
    );
    // Handler to update the completion status of a todo by its ID
    router.addRequest(
      RequestType.PATCH,
      '/api/v1/todos/<id>',
      updateCompletedByIdHandler,
    );
    // Handler to update the completion status of all todos
    router.addRequest(
      RequestType.PATCH,
      '/api/v1/todos',
      updateCompletedForAll,
    );
    // Handler to delete all completed todos
    router.addRequest(
      RequestType.DELETE,
      '/api/v1/todos/completed',
      deleteCompletedHandler,
    );
    // Handler to delete a todo by its ID
    router.addRequest(
      RequestType.DELETE,
      '/api/v1/todos/<id>',
      deleteByIdHandler,
    );
    // Handler to fetch a todo by its ID
    router.addRequest(
      RequestType.GET,
      '/api/v1/todos/<id>',
      fetchTodoByIdHandler,
    );
    router.addRequest(
      RequestType.POST,
      '/api/v1/todos/sync',
      syncTodosHandler,
    );
  }

  /// Handles POST requests to sync todos.
  Future<Response> syncTodosHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final List? todos = params['todos'];
    if (todos == null && todos!.isEmpty) {
      BadRequestException('todos is required');
    }
    final List<$TodoModel> todosList =
        todos.map((todo) => $TodoModel.fromJson(todo)).toList();
    final syncedTodos = todosService.syncAllTodos(todosList);
    final response =
        jsonEncode(syncedTodos.map((obj) => obj.toJson()).toList());

    return Response.ok(response, headers: {'content-type': 'application/json'});
  }

  /// Handles GET requests to fetch all todos.
  Future<Response> getAllTodosHandler(Request request) async {
    final allTodos = todosService.fetchAllTodos();
    final todoList = jsonEncode(allTodos.map((obj) => obj.toJson()).toList());
    return Response.ok(todoList, headers: {'content-type': 'application/json'});
  }

  /// Handles PATCH requests to update the completion status for all todos.
  Future<Response> updateCompletedForAll(Request request) async {
    final params = await request.bodyFromFormData();
    final completed = params['completed'];
    if (completed == null) {
      throw BadRequestException('completed is required');
    }
    final todos = todosService.updateCompletedForAll(completed);
    final todoList = jsonEncode(todos.map((obj) => obj.toJson()).toList());
    return Response.ok(todoList, headers: {'content-type': 'application/json'});
  }

  /// Handles PUT requests to update a todo by its ID.
  Future<Response> updateTodoByIdHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final todoFromRequest = $TodoModel.fromJson(params);
    throwIfEmpty(params['id'], BadRequestException('id is required'));
    final todo = todosService.updateTodoById(todoFromRequest);
    return responseBuilder.buildOK(data: todo.toJson());
  }

  /// Handles POST requests to add a new todo.
  Future<Response> addTodoHandler(Request request) async {
    final params = await request.bodyFromFormData();
    throwIfEmpty(
        params['title'], BadRequestException('Request title is empty'));

    final todoFromRequest = $TodoModel.fromJson(params);
    final todo = todosService.addTodo(todoFromRequest);
    return responseBuilder.buildOK(data: todo.toJson());
  }

  /// Handles PATCH requests to update the completion status of a todo by its ID.
  Future<Response> updateCompletedByIdHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final todoId = request.params['id'];
    final completed = params['completed'];
    if (completed == null) {
      throw BadRequestException('completed is required');
    }
    throwIfEmpty(todoId, BadRequestException('id is required'));
    final todo = todosService.updateCompletedById(todoId!, completed);
    return responseBuilder.buildOK(data: todo.toJson());
  }

  /// Handles DELETE requests to remove all completed todos.
  Future<Response> deleteCompletedHandler(Request request) async {
    final todos = todosService.deleteCompleted();
    final todoList = jsonEncode(todos.map((obj) => obj.toJson()).toList());

    return Response.ok(todoList, headers: {'content-type': 'application/json'});
  }

  /// Handles DELETE requests to remove a todo by its ID.
  Future<Response> deleteByIdHandler(Request request) async {
    final todoId = request.params['id'];

    throwIfEmpty(todoId, BadRequestException('id is required'));

    todosService.deleteById(todoId!);

    return Response(204);
  }

  /// Handles GET requests to fetch a todo by its ID.
  Future<Response> fetchTodoByIdHandler(Request request) async {
    final todoId = request.params['id'];

    throwIfEmpty(todoId, BadRequestException('id is required'));

    final todo = todosService.fetchTodoById(todoId!);

    return responseBuilder.buildOK(data: todo.toJson());
  }
}
