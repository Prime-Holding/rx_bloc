import '../../../integration_test/main/configuration/build_app.dart';
import '../../helpers/golden_helper.dart';
import '../stubs.dart';
import 'factories/verify_pin_factory.dart';

void main() {
  group(
    'Verify Pin golden tests',
    () => runGoldenTests(
      [
        buildScenario(
          widget: verifyPinFactory(),
          scenario: 'verify_pin__empty',
        ),
        buildScenario(
          widget: verifyPinFactory(title: Stubs.title),
          scenario: 'verify_pin__title',
        ),
        buildScenario(
          widget: verifyPinFactory(
            title: Stubs.title,
            showBiometricsButton: true,
          ),
          scenario: 'verify_pin__show_biometrics',
        ),
      ],
    ),
  );
}
