import '../../../helpers/golden_helper.dart';
import '../../../helpers/models/scenario.dart';
import '../../stubs.dart';
import 'factories/app_error_modal_widget_factory.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
      widget: appErrorModalWidgetFactory(error: Stubs.unknownError),
      scenario: Scenario(name: 'app_error_modal'),
    ),
  ]);
}
