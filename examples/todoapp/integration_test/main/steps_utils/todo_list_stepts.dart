import 'package:todoapp/base/models/todos_filter_model.dart';

import '../configuration/build_app.dart';
import '../pages/todo_list_page.dart';

class TodoListSteps {

  static Future<void> navigateToAddTodoPage(PatrolIntegrationTester $) async {
    TodoListPage todoListPage = TodoListPage($);
    await todoListPage.tapBtnAddTodo();
  }

  static Future<void> navigateToTodoDetailsPage(
      PatrolIntegrationTester $, int index) async {
    TodoListPage todoListPage = TodoListPage($);
    await todoListPage.tapTodoListTile(index);
  }

  static Future<void> tapTodoCheckbox(
      PatrolIntegrationTester $, int index) async {
    TodoListPage todoListPage = TodoListPage($);
    await todoListPage.tapTodoCheckbox(index);
  }

  static Future<void> todoFilterButton(
      PatrolIntegrationTester $, TodosFilterModel filter) async {
    TodoListPage todoListPage = TodoListPage($);
    await todoListPage.tapBtnFilter();
    await todoListPage.tapFilterItem(filter);
  }
}
