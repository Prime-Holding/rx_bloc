import 'package:flutter/material.dart';
import 'package:{{project_name}}/base/common_ui_components/app_error_widget.dart';

import '../../../helpers/golden_helper.dart';
import '../../stubs.dart';

void main() {
  runUiComponentGoldenTests(
    scenario: 'unknown_error',
    size: const Size(345, 174),
    children: [
      AppErrorWidget(
        key: const Key('unknown_error default'),
        error: Stubs.unknownError,
        onTabRetry: () {},
      ),
    ],
  );
}
