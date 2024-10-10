import 'package:flutter/cupertino.dart';
import 'package:{{project_name}}/base/common_ui_components/app_loading_indicator.dart';

import '../../../helpers/golden_helper.dart';
import '../../../helpers/models/scenario.dart';
import '../../stubs.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
      widget: const AppLoadingIndicator(),
      scenario: Scenario(name: 'app_loading_indicator_empty'),
    ),
    generateDeviceBuilder(
      widget: const AppLoadingIndicator(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(10),
        size: Size.fromWidth(20),
        strokeWidth: 20,
        color: Stubs.customColor,
      ),
      scenario: Scenario(name: 'app_loading_indicator_with_params'),
    ),
  ]);
}
