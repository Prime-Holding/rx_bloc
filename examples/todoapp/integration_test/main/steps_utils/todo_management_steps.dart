import '../configuration/build_app.dart';
import '../pages/todo_management_page.dart';

class TodoManagementSteps {
  static Future<void> enterTodoTitle(
      PatrolIntegrationTester $, String title) async {
    TodoManagementPage todoManagementPage = TodoManagementPage($);
    await todoManagementPage.enterTodoTitle(title);
  }

  static Future<void> tapBtnAddTodo(PatrolIntegrationTester $) async {
    TodoManagementPage todoManagementPage = TodoManagementPage($);
    await todoManagementPage.tapBtnAddTodo();
  }

  static Future<void> enterTodoDescription(
      PatrolIntegrationTester $, String description) async {
    TodoManagementPage todoManagementPage = TodoManagementPage($);
    await todoManagementPage.enterTodoDescription(description);
  }
}
