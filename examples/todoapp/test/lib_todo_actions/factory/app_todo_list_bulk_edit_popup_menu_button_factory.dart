import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/lib_todo_actions/models/bulk_action.dart';
import 'package:todoapp/lib_todo_actions/ui_components/app_todo_list_bulk_edit_popup_menu_button.dart';

import '../mock/todo_list_bulk_edit_mock.dart';

Widget appTodoListBulkEditPopupMenuButtonFactory({
  List<BulkActionModel> bulkActions = const [],
}) =>
    MultiProvider(
      providers: [
        Provider.value(
          value: todoListBulkEditMockFactory(),
        ),
      ],
      child: const AppTodoListBulkEditPopupMenuButton(),
    );
//AppTodoListBulkEditPopupMenuButton();
