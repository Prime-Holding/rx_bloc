import '../configuration/build_app.dart';
import '../pages/todo_details_page.dart';

class TodoDetailsSteps {
  static Future<void> todoDelete(PatrolIntegrationTester $) async {
    TodoDetailsPage todoDetailsPage = TodoDetailsPage($);

    await todoDetailsPage.tapBtnDeleteTodo();
  }

  static Future<void> navigateToEditScreen(PatrolIntegrationTester $) async {
    TodoDetailsPage todoDetailsPage = TodoDetailsPage($);

    await todoDetailsPage.tapBtnEditTodo();
  }

  static Future<void> tapTodoCheckbox(PatrolIntegrationTester $) async {
    TodoDetailsPage todoDetailsPage = TodoDetailsPage($);
    await todoDetailsPage.tapTodoCheckbox();
  }
}
