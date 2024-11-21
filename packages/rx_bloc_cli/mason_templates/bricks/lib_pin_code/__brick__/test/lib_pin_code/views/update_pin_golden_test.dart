import 'package:flutter_test/flutter_test.dart';

import '../../helpers/golden_helper.dart';
import '../stubs.dart';
import 'factories/update_pin_factory.dart';

void main() {
  group(
    'Update Pin golden tests',
    () => runGoldenTests(
      [
        buildScenario(
          builder: () => updatePinFactory(),
          scenario: 'update_pin_empty',
        ),
        buildScenario(
          builder: () => updatePinFactory(title: Stubs.title),
          scenario: 'update_pin_title',
        ),
        buildScenario(
          builder: () =>
              updatePinFactory(title: Stubs.title, showBiometricsButton: true),
          scenario: 'update_pin_show_biometrics',
        ),
      ],
    ),
  );
}
