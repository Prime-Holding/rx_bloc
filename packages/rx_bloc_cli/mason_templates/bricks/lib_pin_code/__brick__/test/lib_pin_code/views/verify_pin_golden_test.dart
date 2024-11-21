import 'package:flutter_test/flutter_test.dart';

import '../../helpers/golden_helper.dart';
import '../stubs.dart';
import 'factories/verify_pin_factory.dart';

void main() {
  group(
    'Verify Pin golden tests',
    () => runGoldenTests(
      [
        buildScenario(
          builder: () => verifyPinFactory(),
          scenario: 'verify_pin__empty',
        ),
        buildScenario(
          builder: () => verifyPinFactory(title: Stubs.title),
          scenario: 'verify_pin__title',
        ),
        buildScenario(
          builder: () => verifyPinFactory(
            title: Stubs.title,
            showBiometricsButton: true,
          ),
          scenario: 'verify_pin__show_biometrics',
        ),
      ],
    ),
  );
}
