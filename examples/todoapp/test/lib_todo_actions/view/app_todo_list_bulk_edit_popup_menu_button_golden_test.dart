import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../helpers/golden_helper.dart';
import '../../keys/todo_list_keys.dart' as keys;
import '../factory/app_todo_list_bulk_edit_popup_menu_button_factory.dart';

void main() {
  runGoldenBuilderTests(
    'app_todo_list_bulk_edit_popup_menu_button',
    surfaceSize: const Size(200, 330),
    builder: (color) => GoldenBuilder.column(bgColor: color)
      ..addScenario(
        'Button',
        appTodoListBulkEditPopupMenuButtonFactory(),
      )
      ..addScenario(
        'onTap',
        appTodoListBulkEditPopupMenuButtonFactory(
          key: keys.appTodoListBulkEditPopupMenuButtonKey,
        ),
      ),
    act: (tester) async {
      final bulkEditButton =
          find.byKey(keys.appTodoListBulkEditPopupMenuButtonKey);
      expect(bulkEditButton, findsOneWidget);

      await tester.tap(bulkEditButton);
      await tester.pumpAndSettle();
    },
  );
}
