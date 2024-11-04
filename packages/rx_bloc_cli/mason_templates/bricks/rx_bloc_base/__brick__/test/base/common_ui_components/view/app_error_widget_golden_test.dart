import 'dart:ui';

import 'package:{{project_name}}/base/common_ui_components/app_error_widget.dart';

import '../../../helpers/golden_helper.dart';
import '../../../helpers/models/device.dart';
import '../../stubs.dart';

void main() {
  runGoldenTests(
    [
      buildScenario(
        devices: [
          const Device(
            name: 'custom device',
            size: Size(345, 174),
          )
        ],
        scenario: 'unknown_error',
        widget: Scaffold(
          body: AppErrorWidget(
            error: Stubs.unknownError,
            onTabRetry: () {},
          ),
        ),
      ),
    ],
  );
}
