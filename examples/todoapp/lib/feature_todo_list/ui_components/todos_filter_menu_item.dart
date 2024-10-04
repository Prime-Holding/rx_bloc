import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import '../../base/extensions/todo_filter_extensions.dart';
import '../../base/models/todos_filter_model.dart';

PopupMenuItem<TodosFilterModel> buildTodosFilterMenuItem(
  BuildContext context, {
  required TodosFilterModel filter,
  required void Function(TodosFilterModel) onApplyFilter,
  TodosFilterModel? selectedFilter,
}) =>
    PopupMenuItem<TodosFilterModel>(
      key: K.filterByName(filter),
      onTap: () => onApplyFilter(filter),
      child: Text(
        filter.getLabel(context),
        style: context.designSystem.typography.h3Med13
            .copyWith(color: selectedFilter.getColor(context, filter)),
      ),
    );
