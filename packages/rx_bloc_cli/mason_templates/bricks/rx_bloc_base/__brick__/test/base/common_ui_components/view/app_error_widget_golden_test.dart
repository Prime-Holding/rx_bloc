import 'package:{{project_name}}/base/common_ui_components/app_error_widget.dart';

import '../../../helpers/golden_helper.dart';
import '../../../helpers/models/scenario.dart';
import '../../stubs.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
      widget: AppErrorWidget(
        error: Stubs.unknownError,
        onTabRetry: () {},
      ),
      scenario: Scenario(name: 'app_error'),
    ),
  ]);
}
