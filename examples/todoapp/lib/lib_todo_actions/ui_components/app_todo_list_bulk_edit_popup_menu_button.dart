import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../app_extensions.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../blocs/todo_list_bulk_edit_bloc.dart';
import '../models/bulk_action.dart';
import 'app_todo_list_bulk_edit_menu_item.dart';

class AppTodoListBulkEditPopupMenuButton extends StatelessWidget {
  const AppTodoListBulkEditPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) => RxBlocMultiBuilder2<
          TodoListBulkEditBlocType, List<BulkActionModel>, bool>(
        state1: (bloc) => bloc.states.bulkActions,
        state2: (bloc) => bloc.states.isLoading,
        builder: (context, snapshot, isLoading, bloc) => PopupMenuButton(
          child: Builder(
            builder: (context) => SmallButton(
              onPressed: () {
                final popupMenuButton =
                    context.findAncestorStateOfType<PopupMenuButtonState>();
                popupMenuButton?.showButtonMenu();
              },
              state: isLoading.buttonStateModel,
              type: SmallButtonType.icon,
              icon: context.designSystem.icons.menu.icon,
              colorStyle: ButtonColorStyle.fromContext(context).copyWith(
                activeButtonTextColor: context.designSystem.colors.textColor,
              ),
            ),
          ),
          itemBuilder: (context) => snapshot.hasData
              ? snapshot.requireData
                  .map((bulkAction) => buildBulkEditMenuItem(
                        context,
                        bulkAction: bulkAction,
                      ))
                  .toList()
              : [],
        ),
      );
}
