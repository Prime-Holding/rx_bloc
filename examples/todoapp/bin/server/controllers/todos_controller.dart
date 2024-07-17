// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:todoapp/base/models/todo_model.dart';

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
      '/api/todos',
      getAllTodosHandler,
    );
    router.addRequest(
      RequestType.POST,
      '/api/todos',
      addOrUpdateTodoHandler,
    );
    router.addRequest(
      RequestType.GET,
      '/api/todoUpdate/<id>',
      updateCompletedByIdHandler,
    );
    router.addRequest(
      RequestType.PATCH,
      '/api/todos',
      updateCompletedForAll,
    );
    router.addRequest(
      RequestType.DELETE,
      '/api/todos',
      deleteCompletedHandler,
    );
    router.addRequest(
      RequestType.DELETE,
      '/api/todos/<id>',
      deleteByIdHandler,
    );
    router.addRequest(
      RequestType.GET,
      '/api/todoGet/<id>',
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

  Future<Response> addOrUpdateTodoHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final todoFromParams = params['todo'] != null
        ? TodoModel.fromJson(params['todo'])
        : TodoModel.empty();
    //check if the request body is empty
    throwIfEmpty(
        params['title'], BadRequestException('Request title is empty'));
    final todoFromRequest = TodoModel.from(
      title: params['title']!,
      description: params['description'] ?? '',
      todo: todoFromParams,
    );
    final todo = todosService.addOrUpdateReminder(todoFromRequest);
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

    return Response.ok('Todo with id $todoId has been deleted');
  }

  Future<Response> fetchTodoByIdHandler(Request request) async {
    final todoId = request.params['id'];

    throwIfEmpty(todoId, BadRequestException('id is required'));

    final todo = todosService.fetchTodoById(todoId!);

    return responseBuilder.buildOK(data: todo.toJson());
  }
}
