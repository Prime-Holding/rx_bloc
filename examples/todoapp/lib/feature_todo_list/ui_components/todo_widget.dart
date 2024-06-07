import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/models/todo_model.dart';
import '../blocs/todo_list_bloc.dart';

class TodoWidget extends StatelessWidget {
  const TodoWidget({
    super.key,
    required this.todo,
  });

  final TodoModel todo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: todo.completed,
          onChanged: (isChecked) {
            if (todo.id != null) {
              context
                  .read<TodoListBlocType>()
                  .events
                  .updateCompletedById(todo.id!, isChecked!);
            }
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              style: context.designSystem.typography.h2Med16,
              todo.title,
            ),
            if (todo.description.isNotEmpty)
              Text(todo.description),
          ],
        ),
      ],
    );
  }
}
