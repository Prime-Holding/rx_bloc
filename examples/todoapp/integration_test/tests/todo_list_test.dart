import 'package:todoapp/base/models/todos_filter_model.dart';
import 'package:todoapp/lib_todo_actions/models/bulk_action.dart';

import '../main/base/test_constants.dart';
import '../main/base/utils.dart';
import '../main/configuration/build_app.dart';
import '../main/configuration/patrol_base_config.dart';
import '../main/steps_utils/lib_todo_actions_steps.dart';
import '../main/steps_utils/todo_list_stepts.dart';

void main() {
  final patrolBaseConfig = PatrolBaseConfig();

  patrolBaseConfig.patrol('''
    Test the todo list page,
    first add a todo item to todo list,
    then mark it as completed,
    then filter the todos,
    then perform bulk actions on all todos.
    ''', ($) async {
    BuildApp app = BuildApp($);
    await app.buildApp();
    //Create 3 todos
    await Utils.addTodos($, 3);
    // Mark second todo as completed
    await TodoListSteps.tapTodoCheckbox($, 1);

    // Perform filter actions on todos
    await TodoListSteps.todoFilterButton($, TodosFilterModel.completed);
    await TodoListSteps.todoFilterButton($, TodosFilterModel.incomplete);
    await TodoListSteps.todoFilterButton($, TodosFilterModel.all);

    /// Perform build actions on all todos
    await LibTodoActionsSteps.todoAction($, BulkActionModel.markAllComplete);
    await LibTodoActionsSteps.todoAction($, BulkActionModel.markAllIncomplete);
    await LibTodoActionsSteps.todoAction($, BulkActionModel.markAllComplete);
    await LibTodoActionsSteps.todoAction($, BulkActionModel.clearCompleted);
  }, tags: [regressionTest, positiveTest]);
}
