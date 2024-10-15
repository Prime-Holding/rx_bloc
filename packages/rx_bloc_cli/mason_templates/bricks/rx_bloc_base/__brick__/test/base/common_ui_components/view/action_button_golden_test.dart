import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:{{project_name}}/base/common_ui_components/action_button.dart';

import '../../../helpers/golden_helper.dart';
import '../../stubs.dart';

void main() {
  runGoldenBuilderTests(
    'action_button',
    surfaceSize: const Size(70, 304),
    builder: (color) => GoldenBuilder.column(bgColor: color)
      ..addScenario(
        'loading state',
        ActionButton(
          icon: Stubs.addIcon,
          onPressed: () {},
        ),
      )
      ..addScenario(
        'loading state',
        ActionButton(
          icon: Stubs.addIcon,
          onPressed: () {},
          loading: true,
        ),
      ),
    matcherCustomPump: (tester) async {
      await tester.pump();
    },
  );
}
