import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../blocs/todo_list_bulk_edit_bloc.dart';
import '../models/bulk_action.dart';

PopupMenuItem buildBulkEditMenuItem(
  BuildContext context, {
  required BulkActionModel bulkAction,
}) =>
    switch (bulkAction) {
      (BulkActionModel.markAllComplete) => PopupMenuItem(
          key: K.actionByName(bulkAction),
          onTap:
              context.read<TodoListBulkEditBlocType>().events.markAllCompleted,
          child: Text(context.l10n.completeAll),
        ),
      BulkActionModel.markAllIncomplete => PopupMenuItem(
          key: K.actionByName(bulkAction),
          onTap:
              context.read<TodoListBulkEditBlocType>().events.markAllIncomplete,
          child: Text(context.l10n.incompleteAll),
        ),
      BulkActionModel.clearCompleted => PopupMenuItem(
          key: K.actionByName(bulkAction),
          onTap: context.read<TodoListBulkEditBlocType>().events.clearCompleted,
          child: Text(context.l10n.clearCompleted),
        ),
    };
