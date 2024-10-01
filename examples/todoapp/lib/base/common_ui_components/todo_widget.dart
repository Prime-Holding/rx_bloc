import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import '../models/todo_model.dart';

class TodoWidget extends StatelessWidget {
  const TodoWidget({
    super.key,
    required this.todo,
    this.onChanged,
    this.descriptionMaxLines,
  });

  final $TodoModel todo;
  final Function($TodoModel todo, bool? isChecked)? onChanged;
  final int? descriptionMaxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          key: K.todoCheckboxByIndex(todo.id ?? ''),
          value: todo.completed,
          onChanged: onChanged == null
              ? null
              : (isChecked) => onChanged?.call(todo, isChecked),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              style: context.designSystem.typography.h2Med16,
              todo.title,
            ),
            if (todo.description.isNotEmpty)
              Text(
                todo.description,
                maxLines: descriptionMaxLines,
              ),
          ],
        ),
      ],
    );
  }
}
