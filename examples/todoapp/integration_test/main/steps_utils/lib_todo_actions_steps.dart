import 'package:todoapp/lib_todo_actions/models/bulk_action.dart';

import '../configuration/build_app.dart';
import '../pages/lib_todo_actions_page.dart';

class LibTodoActionsSteps {
  static Future<void> todoAction(
      PatrolIntegrationTester $, BulkActionModel action) async {
    LibTodoActionsPage libTodoActionsPage = LibTodoActionsPage($);

    await libTodoActionsPage.tapBtnActions();
    await libTodoActionsPage.tapActionItem(action);
  }
}
