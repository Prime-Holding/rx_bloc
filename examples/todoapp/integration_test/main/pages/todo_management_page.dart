import 'package:todoapp/keys.dart';

import '../base/base_page.dart';
import '../configuration/build_app.dart';

class TodoManagementPage extends BasePage {
  TodoManagementPage(super.$);

  PatrolFinder get locBtnAddTodo => $(K.todoManagementPageFAB);
  PatrolFinder get locTxtFieldTodoTitle => $(K.todoTitleTextField);
  PatrolFinder get locTxtFieldTodoDescription => $(K.todoDescriptionTextField);

  Future<void> enterTodoTitle(String title) async {
    await $(locTxtFieldTodoTitle).enterText(title);
  }

  Future<void> tapBtnAddTodo() async {
    await $(locBtnAddTodo).tap(settlePolicy: SettlePolicy.settle);
  }

  Future<void> enterTodoDescription(String description) async {
    await $(locTxtFieldTodoDescription).enterText(description);
  }
}
