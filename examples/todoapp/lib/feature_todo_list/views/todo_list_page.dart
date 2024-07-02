import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_widget.dart';
import '../../base/common_ui_components/app_loading_indicator.dart';
import '../../base/models/todo_model.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../../lib_todo_actions/di/app_todo_list_bulk_edit_popup_menu_button_with_dependencies.dart';
import '../blocs/todo_list_bloc.dart';
import '../ui_components/todo_list_widget.dart';
import '../ui_components/todos_filter_popup_menu_button.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.todos),
          actions: const [
            TodosFilterPopupMenuButton(),
            AppTodoListBulkEditPopupMenuButtonWithDependencies(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<RouterBlocType>().events.push(TodoCreateRoute());
          },
          shape: const OvalBorder(),
          child: context.designSystem.icons.add,
        ),
        body: RxResultBuilder<TodoListBlocType, List<TodoModel>>(
          state: (bloc) => bloc.states.todoList,
          buildSuccess: (context, list, bloc) => TodoListWidget(todos: list),
          buildError: (context, exception, bloc) => Center(
            child: AppErrorWidget(
              error: exception,
              onTabRetry: () => bloc.events.fetchTodoList(),
            ),
          ),
          buildLoading: (context, bloc) => Center(
            child: AppLoadingIndicator.taskValue(
              context,
              color: context.designSystem.colors.primaryColor,
            ),
          ),
        ),
      );
}
