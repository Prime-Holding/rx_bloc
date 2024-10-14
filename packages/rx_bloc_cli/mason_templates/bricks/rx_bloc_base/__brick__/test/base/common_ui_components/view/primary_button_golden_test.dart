import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:{{project_name}}/base/common_ui_components/primary_button.dart';

import '../../../helpers/golden_helper.dart';
import '../../stubs.dart';

void main() {
  runGoldenBuilderTests('primary_button',
      surfaceSize: const Size(300, 418),
      builder: (_) => GoldenBuilder.column()
        ..addScenario(
          'primary_button_empty',
          const PrimaryButton(),
        )
        ..addScenario(
          'primary_button_empty_loading',
          const PrimaryButton(
            isLoading: true,
          ),
        )
        ..addScenario(
          'primary_button_with_child',
          const PrimaryButton(
            child: Text(Stubs.submit),
          ),
        )
        ..addScenario(
          'primary_button_loading_with_child',
          const PrimaryButton(
            isLoading: true,
            child: Text(Stubs.submit),
          ),
        ),
      matcherCustomPump: (tester) async {
        await tester.pump();
      });
}
