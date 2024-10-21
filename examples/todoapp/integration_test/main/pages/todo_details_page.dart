import 'package:flutter/material.dart';
import 'package:patrol/patrol.dart';
import 'package:todoapp/keys.dart';

import '../base/base_page.dart';

class TodoDetailsPage extends BasePage {
  TodoDetailsPage(super.$);

  PatrolFinder get locBtnDeleteTodo => $(K.todoDetailsPageDeleteButton);
  PatrolFinder get locBtnEditTodo => $(K.todoDetailsPageEditButton);

  Future<void> tapBtnDeleteTodo() async {
    await $(locBtnDeleteTodo).tap();
  }

  Future<void> tapBtnEditTodo() async {
    await $.tester.pumpAndSettle();
    await $(locBtnEditTodo).tap();
  }

  Future<void> tapTodoCheckbox() async {
    await $(Checkbox).tap();
  }
}
