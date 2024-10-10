import 'package:flutter/material.dart';
import 'package:{{project_name}}/base/common_ui_components/primary_button.dart';

import '../../../helpers/golden_helper.dart';
import '../../../helpers/models/scenario.dart';
import '../../stubs.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
      widget: const PrimaryButton(),
      scenario: Scenario(name: 'primary_button_empty'),
    ),
    generateDeviceBuilder(
      widget: const PrimaryButton(
        isLoading: true,
      ),
      scenario: Scenario(name: 'primary_button_empty_loading'),
    ),
    generateDeviceBuilder(
      widget: const PrimaryButton(
        child: Text(Stubs.submit),
      ),
      scenario: Scenario(name: 'primary_button_with_child'),
    ),
    generateDeviceBuilder(
      widget: const PrimaryButton(
        isLoading: true,
        child: Text(Stubs.submit),
      ),
      scenario: Scenario(name: 'primary_button_loading_with_child'),
    ),
  ]);
}
