import 'package:todoapp/assets.dart';
import 'package:todoapp/base/models/errors/error_model.dart';

import '../../Stubs.dart';
import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../factory/todo_management_factory.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
        widget: todoManagementFactory(),
        scenario: Scenario(name: 'todo_management_empty')),
    generateDeviceBuilder(
        widget: todoManagementFactory(onTodoSaved: Stubs.todoUncompleted),
        scenario: Scenario(name: 'todo_management_success')),
    generateDeviceBuilder(
        widget: todoManagementFactory(
            title: Stubs.todoUncompleted.title,
            description: Stubs.todoUncompleted.description),
        scenario: Scenario(name: 'todo_management_edit')),
    generateDeviceBuilder(
        widget: todoManagementFactory(isLoading: true),
        scenario: Scenario(name: 'todo_management_loading')),
    generateDeviceBuilder(
        widget: todoManagementFactory(
            errors: FieldRequiredErrorModel(
          fieldKey: I18nFieldKeys.title,
          fieldValue: Stubs.todoUncompleted.title,
        )),
        scenario: Scenario(name: 'todo_management_global_error')),
    generateDeviceBuilder(
        widget: todoManagementFactory(title: Stubs.shortTitle, showError: true),
        scenario: Scenario(name: 'todo_management_short_title_error'))
  ]);
}
