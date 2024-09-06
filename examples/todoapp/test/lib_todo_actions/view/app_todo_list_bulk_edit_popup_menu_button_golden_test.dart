import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../factory/app_todo_list_bulk_edit_popup_menu_button_factory.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
        widget: appTodoListBulkEditPopupMenuButtonFactory(),
        scenario:
            Scenario(name: 'app_todo_list_bulk_edit_popup_menu_button_empty')),
    generateDeviceBuilder(
        widget: appTodoListBulkEditPopupMenuButtonFactory(),
        scenario: Scenario(
            name: 'app_todo_list_bulk_edit_popup_menu_button_success')),
    generateDeviceBuilder(
        widget: appTodoListBulkEditPopupMenuButtonFactory(),
        scenario: Scenario(
            name: 'app_todo_list_bulk_edit_popup_menu_button_loading')),
    generateDeviceBuilder(
        widget: appTodoListBulkEditPopupMenuButtonFactory(),
        scenario:
            Scenario(name: 'app_todo_list_bulk_edit_popup_menu_button_error'))
  ]);
}
