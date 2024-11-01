import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../stubs.dart';
import 'factories/update_pin_factory.dart';

void main() {
  runGoldenTests(
    [
      generateDeviceBuilder(
        widget: updatePinFactory(),
        scenario: Scenario(name: 'update_pin_empty'),
      ),
      generateDeviceBuilder(
        widget: updatePinFactory(title: Stubs.title),
        scenario: Scenario(name: 'update_pin_title'),
      ),
      generateDeviceBuilder(
        widget:
            updatePinFactory(title: Stubs.title, showBiometricsButton: true),
        scenario: Scenario(name: 'update_pin_show_biometrics'),
      ),
    ],
  );
}
