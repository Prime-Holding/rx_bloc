import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../stubs.dart';
import 'factories/create_pin_factory.dart';

void main() {
  runGoldenTests(
    [
      generateDeviceBuilder(
        widget: createPinFactory(),
        scenario: Scenario(name: 'create_pin_empty'),
      ),
      generateDeviceBuilder(
        widget: createPinFactory(title: Stubs.title),
        scenario: Scenario(name: 'create_pin_title'),
      ),
    ],
  );
}
