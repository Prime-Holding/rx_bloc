import 'package:flutter_test/flutter_test.dart';

import '../../helpers/golden_helper.dart';
import '../stubs.dart';
import 'factories/create_pin_factory.dart';

void main() {
  group(
    'Create Pin golden tests',
    () => runGoldenTests(
      [
        buildScenario(
          widget: createPinFactory(),
          scenario: 'create_pin_empty',
        ),
        buildScenario(
          widget: createPinFactory(title: Stubs.title),
          scenario: 'create_pin_title',
        ),
      ],
    ),
  );
}
