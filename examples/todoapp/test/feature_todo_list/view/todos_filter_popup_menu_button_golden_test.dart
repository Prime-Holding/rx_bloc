import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/base/models/todos_filter_model.dart';

import '../../helpers/golden_helper.dart';
import '../../keys/todo_list_keys.dart' as keys;
import '../factory/todos_filter_popup_menu_button_factory.dart';

void main() {
  runUiComponentGoldenTests(
    scenario: 'todos_filter_popup_menu_button',
    size: const Size(200, 330),
    children: [
      todosFilterPopupMenuButtonFactory(selectedFilter: TodosFilterModel.all),
      todosFilterPopupMenuButtonFactory(
        key: keys.todosFilterPopupMenuButtonKey,
        selectedFilter: TodosFilterModel.completed,
      ),
    ],
    act: (tester) async {
      final filterButton = find.byKey(keys.todosFilterPopupMenuButtonKey);
      expect(filterButton, findsOneWidget);

      await tester.tap(filterButton);
      await tester.pumpAndSettle();
    },
  );
}
