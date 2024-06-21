import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/base/models/errors/error_model.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/feature_todo_management/blocs/todo_management_bloc.dart';
import 'package:todoapp/feature_todo_management/views/todo_management_page.dart';

import '../mock/todo_management_mock.dart';


/// Change the parameters according the the needs of the test
Widget todoManagementFactory({
  String? title,
  String? description,
  bool? showError,
  bool? isLoading,
  ErrorModel? errors,
  TodoModel? onTodoSaved,
}) =>
    Scaffold(
      body: MultiProvider(providers: [
        RxBlocProvider<TodoManagementBlocType>.value(
          value: todoManagementMockFactory(
            title: title,
            description: description,
            showError: showError,
            isLoading: isLoading,
            errors: errors,
            onTodoSaved: onTodoSaved,

          ),
        ),
      ], child: const TodoManagementPage()),
    );
