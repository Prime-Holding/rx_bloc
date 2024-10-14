import 'dart:ui';

import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:{{project_name}}/base/common_ui_components/update_button.dart';

import '../../../helpers/golden_helper.dart';

void main() {
  runGoldenBuilderTests(
    'update_button',
    surfaceSize: const Size(200, 256),
    builder: (_) => GoldenBuilder.column()
      ..addScenario(
        'update_button_active',
        UpdateButton(isActive: true, onPressed: () {}),
      )
      ..addScenario(
        'update_button_not_active',
        UpdateButton(isActive: false, onPressed: () {}),
      ),
  );
}
