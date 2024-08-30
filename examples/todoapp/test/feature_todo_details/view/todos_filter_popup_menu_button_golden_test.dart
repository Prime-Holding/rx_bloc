import 'package:todoapp/base/models/todos_filter_model.dart';

import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../factory/todos_filter_popup_menu_button_factory.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
        widget: todoFilterPopupMenuButtonFactory(filter: TodosFilterModel.all),
        scenario: Scenario(name: 'todos_filter_popup_menu_button_all')),
    generateDeviceBuilder(
        widget: todoFilterPopupMenuButtonFactory(
            filter: TodosFilterModel.incomplete),
        scenario: Scenario(name: 'todos_filter_popup_menu_button_incomplete')),
    generateDeviceBuilder(
        widget: todoFilterPopupMenuButtonFactory(
            filter: TodosFilterModel.completed),
        scenario: Scenario(name: 'todos_filter_popup_menu_button_completed')),
  ]);
}
