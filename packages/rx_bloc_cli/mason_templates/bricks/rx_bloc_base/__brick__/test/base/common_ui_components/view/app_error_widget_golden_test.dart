import 'dart:ui';

import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:{{project_name}}/base/common_ui_components/app_error_widget.dart';

import '../../../helpers/golden_helper.dart';
import '../../stubs.dart';

void main() {
  runGoldenBuilderTests('app_error',
      surfaceSize: const Size(345, 174),
      builder: (_) => GoldenBuilder.column()
        ..addScenario(
          'unknown error',
          AppErrorWidget(
            error: Stubs.unknownError,
            onTabRetry: () {},
          ),
        ));
}
