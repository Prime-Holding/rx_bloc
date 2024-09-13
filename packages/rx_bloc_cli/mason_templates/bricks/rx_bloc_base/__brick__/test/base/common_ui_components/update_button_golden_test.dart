import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:testapp/base/common_ui_components/update_button.dart';

import '../../helpers/golden_helper.dart';

void main() {
  runGoldenBuilderTests(
    'update_button',
    surfaceSize: const Size(87, 204),
    builder: (color) => GoldenBuilder.column(bgColor: color)
      ..addScenario(
        'Active',
        UpdateButton(
          isActive: true,
          onPressed: () {},
        ),
      )
      ..addScenario(
        'Inactive',
        UpdateButton(
          isActive: false,
          onPressed: () {},
        ),
      ),
  );
}
