// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/todo_model.dart';

part 'todos_remote_data_source.g.dart';

/// Used as a contractor for remote data source.
/// To make it work, should provide a real API and rerun build_runner
@RestApi()
abstract class TodosRemoteDataSource {
  factory TodosRemoteDataSource(Dio dio, {String baseUrl}) =
      _TodosRemoteDataSource;

  @POST('/api/v1/todos/sync')
  Future<List<$TodoModel>> syncTodos(@Body() Map<String, dynamic> todos);

  @GET('/api/v1/todos')
  Future<List<$TodoModel>> getAllTodos();

  @POST('/api/v1/todos')
  Future<$TodoModel> addTodo(
    @Body() $TodoModel todo,
  );

  @PUT('/api/v1/todos/{id}')
  Future<$TodoModel> updateTodoById(
    @Path('id') String id,
    @Body() $TodoModel todo,
  );

  @PATCH('/api/v1/todos/{id}')
  Future<$TodoModel> updateCompletedById(
    @Path('id') String id,
    @Body() Map<String, dynamic> completed,
  );

  @PATCH('/api/v1/todos')
  Future<List<$TodoModel>> updateCompletedForAll(
      @Body() Map<String, dynamic> completed);

  @DELETE('/api/v1/todos/completed')
  Future<List<$TodoModel>> deleteCompleted();

  @DELETE('/api/v1/todos/{id}')
  Future<void> deleteTodoById(
    @Path('id') String id,
  );

  @GET('/api/v1/todos/{id}')
  Future<$TodoModel> getTodoById(
    @Path('id') String id,
  );
}
