import '../main/base/utils.dart';
import '../main/configuration/build_app.dart';
import '../main/configuration/patrol_base_config.dart';
import '../main/steps_utils/todo_details_steps.dart';
import '../main/steps_utils/todo_list_stepts.dart';

void main() {
  final patrolBaseConfig = PatrolBaseConfig();

  patrolBaseConfig.patrol(
    '''
    Add a todo item with title and description to todo list,
    Then navigate to todo details page and mark the todo as completed,
    Then delete the todo item.
    ''',
    ($) async {
      BuildApp app = BuildApp($);
      await app.buildApp();
      //Create a todo
      await Utils.addTodos($, 1);
      // Navigate to todo details page
      await TodoListSteps.navigateToTodoDetailsPage($, 0);
      // Mark todo as completed
      await TodoDetailsSteps.tapTodoCheckbox($);
      // Delete todo
      await TodoDetailsSteps.todoDelete($);
    },
  );
}
