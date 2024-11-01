import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../stubs.dart';
import 'factories/verify_pin_factory.dart';

void main() {
  runGoldenTests(
    [
      generateDeviceBuilder(
        widget: verifyPinFactory(),
        scenario: Scenario(name: 'verify_pin__empty'),
      ),
      generateDeviceBuilder(
        widget: verifyPinFactory(title: Stubs.title),
        scenario: Scenario(name: 'verify_pin__title'),
      ),
      generateDeviceBuilder(
        widget: verifyPinFactory(
          title: Stubs.title,
          showBiometricsButton: true,
        ),
        scenario: Scenario(name: 'verify_pin__show_biometrics'),
      ),
    ],
  );
}
