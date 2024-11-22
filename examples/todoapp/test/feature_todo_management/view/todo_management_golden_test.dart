import 'package:todoapp/assets.dart';
import 'package:todoapp/base/models/errors/error_model.dart';

import '../../helpers/golden_helper.dart';
import '../../stubs.dart';
import '../factory/todo_management_factory.dart';

void main() {
  runGoldenTests([
    buildScenario(
      scenario: 'todo_management_empty',
      widget: todoManagementFactory(),
    ),
    buildScenario(
      scenario: 'todo_management_success',
      widget: todoManagementFactory(onTodoSaved: Stubs.todoIncomplete),
    ),
    buildScenario(
      scenario: 'todo_management_edit',
      widget: todoManagementFactory(
          title: Stubs.todoIncomplete.title,
          description: Stubs.todoIncomplete.description),
    ),
    buildScenario(
      scenario: 'todo_management_loading',
      widget: todoManagementFactory(isLoading: true),
    ),
    buildScenario(
      scenario: 'todo_management_global_error',
      widget: todoManagementFactory(
          errors: FieldRequiredErrorModel(
        fieldKey: I18nFieldKeys.title,
        fieldValue: Stubs.todoIncomplete.title,
      )),
    ),
    buildScenario(
      scenario: 'todo_management_short_title_error',
      widget: todoManagementFactory(title: Stubs.shortTitle, showError: true),
    ),
  ]);
}
