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
          widget: updatePinFactory(),
          scenario: 'update_pin_empty',
        ),
        buildScenario(
          widget: updatePinFactory(title: Stubs.title),
          scenario: 'update_pin_title',
        ),
        buildScenario(
          widget:
              updatePinFactory(title: Stubs.title, showBiometricsButton: true),
          scenario: 'update_pin_show_biometrics',
        ),
      ],
    ),
  );
}
