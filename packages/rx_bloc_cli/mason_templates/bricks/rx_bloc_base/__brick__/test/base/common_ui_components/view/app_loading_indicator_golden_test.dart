import 'package:flutter/cupertino.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:{{project_name}}/base/common_ui_components/app_loading_indicator.dart';

import '../../../helpers/golden_helper.dart';
import '../../stubs.dart';

void main() {
  runGoldenBuilderTests('loading_indicator',
      surfaceSize: const Size(300, 218),
      builder: (_) => GoldenBuilder.column()
        ..addScenario(
          'app_loading_indicator_empty',
          const AppLoadingIndicator(),
        )
        ..addScenario(
          'app_loading_indicator_with_params',
          const AppLoadingIndicator(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(10),
            size: Size(20, 20),
            strokeWidth: 20,
            color: Stubs.customColor,
          ),
        ),
      matcherCustomPump: (tester) async {
        await tester.pump();
      });
}
