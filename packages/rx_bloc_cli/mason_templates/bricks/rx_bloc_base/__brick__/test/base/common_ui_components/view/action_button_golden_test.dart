import 'package:{{project_name}}/base/common_ui_components/action_button.dart';

import '../../../helpers/golden_helper.dart';
import '../../../helpers/models/scenario.dart';
import '../../stubs.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
      widget: ActionButton(
        icon: Stubs.addIcon,
        onPressed: () {},
      ),
      scenario: Scenario(name: 'action_button_simple'),
    ),
    generateDeviceBuilder(
      widget: ActionButton(
        icon: Stubs.addIcon,
        onPressed: () {},
        tooltip: Stubs.tooltip,
      ),
      scenario: Scenario(name: 'action_button_with_tooltip'),
    ),
    generateDeviceBuilder(
      widget: ActionButton(
        icon: Stubs.addIcon,
        onPressed: () {},
        tooltip: Stubs.tooltip,
        loading: true,
      ),
      scenario: Scenario(name: 'action_button_loading'),
    ),
  ]);
}
