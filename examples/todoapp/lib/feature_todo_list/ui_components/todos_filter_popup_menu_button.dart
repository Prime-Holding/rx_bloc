import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../app_extensions.dart';
import '../../base/models/todos_filter_model.dart';
import '../blocs/todo_list_bloc.dart';

class TodosFilterPopupMenuButton extends StatelessWidget {
  const TodosFilterPopupMenuButton({super.key});
  @override
  Widget build(BuildContext context) =>
      RxBlocBuilder<TodoListBlocType, TodosFilterModel>(
        state: (bloc) => bloc.states.filter,
        builder: (context, snapshot, bloc) => PopupMenuButton(
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
          onSelected: (filter) => bloc.events.applyFilter(filter),
          itemBuilder: (context) => TodosFilterModel.values
              .map((filter) => switch (filter) {
                    (TodosFilterModel.all) => PopupMenuItem(
                        onTap: () => bloc.events.applyFilter(filter),
                        child: Text(
                          context.l10n.showAll,
                          style: context.designSystem.typography.h3Med13
                              .copyWith(
                                  color: snapshot.getColor(context, filter)),
                        ),
                      ),
                    TodosFilterModel.incomplete => PopupMenuItem(
                        onTap: () => bloc.events.applyFilter(filter),
                        child: Text(
                          context.l10n.showActive,
                          style: context.designSystem.typography.h3Med13
                              .copyWith(
                                  color: snapshot.getColor(context, filter)),
                        ),
                      ),
                    TodosFilterModel.completed => PopupMenuItem(
                        onTap: () => bloc.events.applyFilter(filter),
                        child: Text(
                          context.l10n.showCompleted,
                          style: context.designSystem.typography.h3Med13
                              .copyWith(
                                  color: snapshot.getColor(context, filter)),
                        ),
                      ),
                  })
              .toList(),
        ),
      );
}

extension _Color on AsyncSnapshot<TodosFilterModel> {
  Color getColor(BuildContext context, TodosFilterModel filter) =>
      hasData && requireData == filter
          ? context.designSystem.colors.activeButtonColor
          : context.designSystem.colors.inactiveButtonColor;
}
