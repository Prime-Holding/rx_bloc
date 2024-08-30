import 'package:todoapp/lib_todo_actions/models/bulk_action.dart';
import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../factory/app_todo_list_bulk_edit_popup_menu_button_factory.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
        widget: appTodoListBulkEditPopupMenuButtonFactory(bulkActions: [
          BulkActionModel.markAllComplete,
          BulkActionModel.markAllIncomplete,
          BulkActionModel.clearCompleted
        ]),
        scenario:
            Scenario(name: 'app_todo_list_bulk_edit_popup_menu_button_all')),
    generateDeviceBuilder(
        widget: appTodoListBulkEditPopupMenuButtonFactory(
            bulkActions: [BulkActionModel.markAllIncomplete]),
        scenario: Scenario(
            name: 'app_todo_list_bulk_edit_popup_menu_button_incomplete')),
    generateDeviceBuilder(
        widget: appTodoListBulkEditPopupMenuButtonFactory(
            bulkActions: [BulkActionModel.markAllComplete]),
        scenario: Scenario(
            name: 'app_todo_list_bulk_edit_popup_menu_button_completed')),
  ]);
}
