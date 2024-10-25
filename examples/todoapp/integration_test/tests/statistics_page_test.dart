import 'package:todoapp/lib_todo_actions/models/bulk_action.dart';

import '../main/base/tags.dart';
import '../main/base/utils.dart';
import '../main/configuration/build_app.dart';
import '../main/configuration/patrol_base_config.dart';
import '../main/steps_utils/home_steps.dart';
import '../main/steps_utils/lib_todo_actions_steps.dart';

void main() {
  final patrolBaseConfig = PatrolBaseConfig();

  patrolBaseConfig.patrol('''
    Add 3 todo items with title and description to todo list,
    Then navigate to statistics page and perform bulk actions on all todos.
    ''', ($) async {
    BuildApp app = BuildApp($);
    await app.buildApp();

    //Create 3 todos
    await Utils.addTodos($, 3);
    //Navigate to statistics page
    await HomeSteps.navigateToStatisticsPage($);
    //Perform bulk actions on all todos
    await LibTodoActionsSteps.todoAction($, BulkActionModel.markAllComplete);
    await LibTodoActionsSteps.todoAction($, BulkActionModel.markAllIncomplete);
    await LibTodoActionsSteps.todoAction($, BulkActionModel.markAllComplete);
    await LibTodoActionsSteps.todoAction($, BulkActionModel.clearCompleted);
  }, tags: [regressionTest, positiveTest]);
}
