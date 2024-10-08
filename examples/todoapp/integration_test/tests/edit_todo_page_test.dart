import '../main/base/test_constants.dart';
import '../main/base/utils.dart';
import '../main/configuration/build_app.dart';
import '../main/configuration/patrol_base_config.dart';
import '../main/steps_utils/todo_details_steps.dart';
import '../main/steps_utils/todo_list_stepts.dart';
import '../main/steps_utils/todo_management_steps.dart';

void main() {
  final patrolBaseConfig = PatrolBaseConfig();

  patrolBaseConfig.patrol('''
    Add a todo item with title and description to todo list,
    Then navigate to edit todo page and edit the todo item,
    ''', ($) async {
    BuildApp app = BuildApp($);
    await app.buildApp();
    //Add a todo
    await Utils.addTodos($, 1);
    // Navigate to todo details page
    await TodoListSteps.navigateToTodoDetailsPage($, 0);
    // Navigate to edit todo page
    await TodoDetailsSteps.navigateToEditScreen($);
    // Enter new title
    await TodoManagementSteps.enterTodoTitle($, 'Edited Todo 1');
    // Enter new description
    await TodoManagementSteps.enterTodoDescription($, 'Edited Description 1');
    // Tap on update button
    await TodoManagementSteps.tapBtnAddTodo($);
  }, tags: [regressionTest, positiveTest]);
}
