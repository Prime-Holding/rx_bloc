import 'package:flutter/material.dart';
import 'package:todoapp/base/models/todos_filter_model.dart';
import 'package:todoapp/feature_todo_list/ui_components/todos_filter_popup_menu_button.dart';

/// Change the parameters according the the needs of the test
Widget todosFilterPopupMenuButtonFactory({
  TodosFilterModel? selectedFilter,
  Key? key,
}) =>
    TodosFilterPopupMenuButton(
      selectedFilter: selectedFilter,
      onApplyFilter: (_) {},
      key: key,
    );
