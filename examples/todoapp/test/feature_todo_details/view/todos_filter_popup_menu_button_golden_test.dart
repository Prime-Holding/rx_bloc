import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../factory/todos_filter_popup_menu_button_factory.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
        widget: todosFilterPopupMenuButtonFactory(), //example: Stubs.emptyList
        scenario: Scenario(name: 'todos_filter_popup_menu_button_empty')),
    generateDeviceBuilder(
        widget: todosFilterPopupMenuButtonFactory(), //example:  Stubs.success
        scenario: Scenario(name: 'todos_filter_popup_menu_button_success')),
    generateDeviceBuilder(
        widget: todosFilterPopupMenuButtonFactory(), //loading
        scenario: Scenario(name: 'todos_filter_popup_menu_button_loading')),
    generateDeviceBuilder(
        widget: todosFilterPopupMenuButtonFactory(),
        scenario: Scenario(name: 'todos_filter_popup_menu_button_error'))
  ]);
}
