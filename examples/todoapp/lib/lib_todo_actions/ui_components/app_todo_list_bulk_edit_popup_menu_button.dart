import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../blocs/todo_list_bulk_edit_bloc.dart';
import '../models/bulk_action.dart';

class AppTodoListBulkEditPopupMenuButton extends StatelessWidget {
  const AppTodoListBulkEditPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) =>
      RxBlocBuilder<TodoListBulkEditBlocType, List<BulkActionModel>>(
        state: (bloc) => bloc.states.bulkActions,
        builder: (context, snapshot, bloc) => PopupMenuButton(
          icon: context.designSystem.icons.menu,
          itemBuilder: (context) => snapshot.hasData
              ? snapshot.requireData
                  .map((actionModel) => _buildMenuItem(actionModel, context))
                  .toList()
              : [],
        ),
      );

  PopupMenuItem _buildMenuItem(
    BulkActionModel actionModel,
    BuildContext context,
  ) =>
      switch (actionModel) {
        (BulkActionModel.markAllComplete) => PopupMenuItem(
            onTap: context
                .read<TodoListBulkEditBlocType>()
                .events
                .markAllCompleted,
            child: Text(context.l10n.completeAll),
          ),
        BulkActionModel.markAllIncomplete => PopupMenuItem(
            onTap: context
                .read<TodoListBulkEditBlocType>()
                .events
                .markAllIncomplete,
            child: Text(context.l10n.incompleteAll),
          ),
        BulkActionModel.clearCompleted => PopupMenuItem(
            onTap:
                context.read<TodoListBulkEditBlocType>().events.clearCompleted,
            child: Text(context.l10n.clearCompleted),
          ),
      };
}
