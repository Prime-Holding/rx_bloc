import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:todoapp/base/models/errors/error_model.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/feature_todo_details/blocs/todo_details_bloc.dart';
import 'package:todoapp/feature_todo_details/views/todo_details_page.dart';

import '../mock/todo_details_mock.dart';

/// Change the parameters according the the needs of the test
Widget todoDetailsFactory({
  bool? isLoading,
  ErrorModel? errors,
  Result<TodoModel>? todo,
}) {
    return Scaffold(
      body: MultiProvider(providers: [
        RxBlocProvider<TodoDetailsBlocType>.value(
          value: todoDetailsMockFactory(
            isLoading: isLoading,
            errors: errors,
            todo: todo,
          ),
        ),
      ], child: TodoDetailsPage(id: todo != null && todo is ResultSuccess<TodoModel> ? todo.data.id ?? '' : '')),
    );
}
