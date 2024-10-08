import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/todo_widget.dart';
import '../../base/models/todo_model.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../../lib_todo_actions/blocs/todo_actions_bloc.dart';

class TodoListWidget extends StatelessWidget {
  const TodoListWidget({
    required this.todos,
    required this.isLoading,
    super.key,
  });

  final List<$TodoModel> todos;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return Center(
        child: Text(
          textAlign: TextAlign.center,
          context.l10n.emptyTodoList,
        ),
      );
    }

    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: todos.length,
      itemBuilder: (context, index) => InkWell(
        key: Key(index.toString()),
        onTap: isLoading
            ? null
            : () => context.read<RouterBlocType>().events.push(
                  TodoDetailsRoute(id: todos[index].id ?? ''),
                  extra: todos[index],
                ),
        child: TodoWidget(
          todo: todos[index],
          descriptionMaxLines: 1,
          onChanged: isLoading
              ? null
              : (todo, isChecked) {
                  if (todo.id != null) {
                    context
                        .read<TodoActionsBlocType>()
                        .events
                        .updateCompletedById(todo.id!, isChecked!);
                  }
                },
        ),
      ),
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
