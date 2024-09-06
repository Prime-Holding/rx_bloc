import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/base/models/todos_filter_model.dart';
import 'package:todoapp/feature_todo_list/blocs/todo_list_bloc.dart';
import 'package:todoapp/feature_todo_list/views/todo_list_page.dart';
import 'package:todoapp/lib_todo_actions/blocs/todo_actions_bloc.dart';
import 'package:todoapp/lib_todo_actions/blocs/todo_list_bulk_edit_bloc.dart';
import 'package:todoapp/lib_todo_actions/models/bulk_action.dart';

import '../../lib_todo_actions/mock/todo_actions_mock.dart';
import '../../lib_todo_actions/mock/todo_list_bulk_edit_mock.dart';
import '../mock/todo_list_mock.dart';

/// Change the parameters according the the needs of the test
Widget todoListFactory({
  Result<List<$TodoModel>>? todoList,
  TodosFilterModel? filter,
  List<BulkActionModel>? bulkActions,
}) =>
    Scaffold(
      body: MultiProvider(providers: [
        RxBlocProvider<TodoListBlocType>.value(
          value: todoListMockFactory(
            todoList: todoList,
            filter: filter,
          ),
        ),
        RxBlocProvider<TodoActionsBlocType>.value(
          value: todoActionsMockFactory(),
        ),
        RxBlocProvider<TodoListBulkEditBlocType>.value(
          value: todoListBulkEditMockFactory(),
        ),
      ], child: const TodoListPage()),
    );
