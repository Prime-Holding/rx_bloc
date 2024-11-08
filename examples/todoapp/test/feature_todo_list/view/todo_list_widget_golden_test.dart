import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/keys.dart';

import '../../helpers/golden_helper.dart';
import '../../stubs.dart';
import '../ui_components/todo_list_widget_factory.dart';

void main() {
  runUiComponentGoldenTests(
      scenario: 'todo_list_success_checkbox_onTap',
      size: const Size(600, 500),
      children: [
        SizedBox(
          key: const Key('listtile_widget_tap'),
          height: 400,
          child: todoListWidgetFactory(
            todos: Stubs.todoListCustomId,
          ),
        ),
      ],
      act: (tester) async {
        await tester.tap(find
            .byKey(K.todoCheckboxByIndex(Stubs.todoListCustomId[0].id ?? '')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(K.todoCheckboxByIndex('someLongId123')));
        await tester.pumpAndSettle();
      });
}
