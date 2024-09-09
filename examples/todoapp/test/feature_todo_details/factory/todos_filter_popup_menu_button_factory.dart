import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/base/models/todos_filter_model.dart';
import 'package:todoapp/feature_todo_list/blocs/todo_list_bloc.dart';
import 'package:todoapp/feature_todo_list/ui_components/todos_filter_popup_menu_button.dart';

import '../blocs/todo_list_bloc_factory.dart';

/// Change the parameters according the the needs of the test
Widget todoFilterPopupMenuButtonFactory({
  Result<List<TodoModel>>? todos,
  TodosFilterModel? filter,
}) {
  return Scaffold(
    body: MultiProvider(
      providers: [
        RxBlocProvider<TodoListBlocType>.value(
          value: todoListBlocMockFactory(
            todosList: todos,
            filter: filter,
          ),
        ),
      ],
      child: TodosFilterPopupMenuButton(),
    ),
  );
}
