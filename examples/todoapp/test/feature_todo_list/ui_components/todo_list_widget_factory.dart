import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/feature_todo_list/ui_components/todo_list_widget.dart';
import 'package:todoapp/lib_router/blocs/router_bloc.dart';
import 'package:todoapp/lib_todo_actions/blocs/todo_actions_bloc.dart';
import 'package:todoapp/lib_todo_actions/blocs/todo_list_bulk_edit_bloc.dart';

import '../../base/common_blocs/router_bloc_mock.dart';
import '../../lib_todo_actions/mock/todo_actions_mock.dart';
import '../../lib_todo_actions/mock/todo_list_bulk_edit_mock.dart';

/// Change the parameters according the the needs of the test
Widget todoListWidgetFactory({
  List<$TodoModel> todos = const [],
  bool isLoading = false,
  Key? key,
}) =>
    MultiProvider(
      providers: [
        RxBlocProvider<RouterBlocType>.value(
          value: routerBlocMockFactory(),
        ),
        RxBlocProvider<TodoActionsBlocType>.value(
          value: todoActionsMockFactory(
            isLoading: isLoading,
          ),
        ),
        RxBlocProvider<TodoListBulkEditBlocType>.value(
          value: todoListBulkEditMockFactory(
            isLoading: isLoading,
          ),
        ),
      ],
      child: Scaffold(
        body: TodoListWidget(
          key: key,
          todos: todos,
          isLoading: isLoading,
        ),
      ),
    );
