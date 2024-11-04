import '../main/base/tags.dart';
import '../main/configuration/build_app.dart';
import '../main/configuration/patrol_base_config.dart';
import '../main/steps_utils/todo_list_stepts.dart';
import '../main/steps_utils/todo_management_steps.dart';

void main() {
  final patrolBaseConfig = PatrolBaseConfig();

  patrolBaseConfig.patrol(
    'Add a todo item without title to todo list',
    ($) async {
      BuildApp app = BuildApp($);
      await app.buildApp();
      // Navigate to add todo page
      await TodoListSteps.navigateToAddTodoPage($);
      // Enter todo description
      await TodoManagementSteps.enterTodoDescription($, 'Description 1');
      // Tap on add button
      await TodoManagementSteps.tapBtnAddTodo($);
    },
    tags: [negativeTest],
  );
}
