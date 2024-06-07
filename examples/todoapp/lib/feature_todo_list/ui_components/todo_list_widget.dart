import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/models/todo_model.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import 'todo_widget.dart';

class TodoListWidget extends StatelessWidget {
  const TodoListWidget({
    super.key,
    required this.todos,
  });

  final List<TodoModel> todos;

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
    return Expanded(
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: todos.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () => {
            context.read<RouterBlocType>().events.push(
                  TodoDetailsRoute(id: todos[index].id ?? ''),
                  extra: todos[index],
                )
          },
          child: TodoWidget(todo: todos[index]),
        ),
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
