// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../services/todos_service.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

class TodosController extends ApiController {
  TodosController(this.todosService);

  final TodosService todosService;

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.GET,
      '/api/v1/todos',
      getAllTodosHandler,
    );
    router.addRequest(
      RequestType.POST,
      '/api/v1/todos',
      addTodoHandler,
    );
    router.addRequest(
      RequestType.PUT,
      '/api/v1/todos/<id>',
      updateTodoByIdHandler,
    );
    router.addRequest(
      RequestType.PATCH,
      '/api/v1/todos/<id>',
      updateCompletedByIdHandler,
    );
    router.addRequest(
      RequestType.PATCH,
      '/api/v1/todos',
      updateCompletedForAll,
    );
    router.addRequest(
      RequestType.DELETE,
      '/api/v1/todos/completed',
      deleteCompletedHandler,
    );
    router.addRequest(
      RequestType.DELETE,
      '/api/v1/todos/<id>',
      deleteByIdHandler,
    );
    router.addRequest(
      RequestType.GET,
      '/api/v1/todos/<id>',
      fetchTodoByIdHandler,
    );
  }

  Future<Response> getAllTodosHandler(Request request) async {
    final allTodos = todosService.fetchAllTodos();
    return responseBuilder.buildOK(data: allTodos.toJson());
  }

  Future<Response> updateCompletedForAll(Request request) async {
    final params = await request.bodyFromFormData();
    final completed = params['completed'];
    if (completed == null) {
      throw BadRequestException('completed is required');
    }
    final todos = todosService.updateCompletedForAll(completed);
    return responseBuilder.buildOK(data: todos.toJson());
  }

  Future<Response> updateTodoByIdHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final title = params['title'];
    final description = params['description'];
    throwIfEmpty(params['id'], BadRequestException('id is required'));
    final todo = todosService.updateTodoById(params['id'], title, description);
    return responseBuilder.buildOK(data: todo.toJson());
  }

  Future<Response> addTodoHandler(Request request) async {
    final params = await request.bodyFromFormData();

    throwIfEmpty(
        params['title'], BadRequestException('Request title is empty'));

    final todo = todosService.addTodo(
      params['title']!,
      params['description'],
    );
    return responseBuilder.buildOK(data: todo.toJson());
  }

  Future<Response> updateCompletedByIdHandler(Request request) async {
    final todoId = request.params['id'];

    throwIfEmpty(todoId, BadRequestException('id is required'));
    final todo = todosService.updateCompletedById(todoId!);
    return responseBuilder.buildOK(data: todo.toJson());
  }

  Future<Response> deleteCompletedHandler(Request request) async {
    final todos = todosService.deleteCompleted();
    return responseBuilder.buildOK(data: todos.toJson());
  }

  Future<Response> deleteByIdHandler(Request request) async {
    final todoId = request.params['id'];

    throwIfEmpty(todoId, BadRequestException('id is required'));

    todosService.deleteById(todoId!);

    return Response(204);
  }

  Future<Response> fetchTodoByIdHandler(Request request) async {
    final todoId = request.params['id'];

    throwIfEmpty(todoId, BadRequestException('id is required'));

    final todo = todosService.fetchTodoById(todoId!);

    return responseBuilder.buildOK(data: todo.toJson());
  }
}
