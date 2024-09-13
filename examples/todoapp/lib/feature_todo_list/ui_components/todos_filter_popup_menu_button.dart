import 'package:flutter/material.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../app_extensions.dart';
import '../../base/models/todos_filter_model.dart';
import 'todos_filter_menu_item.dart';

class TodosFilterPopupMenuButton extends StatelessWidget {
  const TodosFilterPopupMenuButton({
    required this.selectedFilter,
    required this.onApplyFilter,
    super.key,
  });

  final TodosFilterModel? selectedFilter;
  final void Function(TodosFilterModel) onApplyFilter;

  @override
  Widget build(BuildContext context) => PopupMenuButton<TodosFilterModel>(
        itemBuilder: (_) => TodosFilterModel.values
            .map((filter) => buildTodosFilterMenuItem(
                  context,
                  filter: filter,
                  onApplyFilter: onApplyFilter,
                  selectedFilter: selectedFilter,
                ))
            .toList(),
        child: Builder(
          builder: (context) => SmallButton(
            type: SmallButtonType.icon,
            icon: context.designSystem.icons.filter.icon,
            colorStyle: ButtonColorStyle.fromContext(context).copyWith(
              activeButtonTextColor: context.designSystem.colors.textColor,
            ),
            onPressed: () {
              final popupMenuButton =
                  context.findAncestorStateOfType<PopupMenuButtonState>();
              popupMenuButton?.showButtonMenu();
            },
          ),
        ),
      );
}
