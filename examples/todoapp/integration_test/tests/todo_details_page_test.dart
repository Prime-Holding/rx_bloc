import '../main/base/tags.dart';
import '../main/base/utils.dart';
import '../main/configuration/build_app.dart';
import '../main/configuration/patrol_base_config.dart';
import '../main/steps_utils/todo_details_steps.dart';
import '../main/steps_utils/todo_list_stepts.dart';

void main() {
  final patrolBaseConfig = PatrolBaseConfig();

  patrolBaseConfig.patrol(
    'Todo details page test',
    ($) async {
      BuildApp app = BuildApp($);
      await app.buildApp();
      // Create a todo
      await Utils.addTodos($, 1);
      // Navigate to todo details page
      await TodoListSteps.navigateToTodoDetailsPage($, 0);
      // Mark todo as completed
      await TodoDetailsSteps.tapTodoCheckbox($);
      // Delete todo
      await TodoDetailsSteps.todoDelete($);
    },
    tags: [regressionTest, positiveTest],
  );
}
