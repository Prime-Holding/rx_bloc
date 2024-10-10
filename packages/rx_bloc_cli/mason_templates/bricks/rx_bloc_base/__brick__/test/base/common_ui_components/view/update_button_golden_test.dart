import 'package:{{project_name}}/base/common_ui_components/update_button.dart';

import '../../../helpers/golden_helper.dart';
import '../../../helpers/models/scenario.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
      widget: UpdateButton(isActive: true, onPressed: () {}),
      scenario: Scenario(name: 'update_button_active'),
    ),
    generateDeviceBuilder(
      widget: UpdateButton(isActive: false, onPressed: () {}),
      scenario: Scenario(name: 'update_button_not_active'),
    ),
  ]);
}
