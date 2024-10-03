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
      generateDeviceBuilder(
        widget: createPinFactory(title: Stubs.title, isSessionTimeout: true),
        scenario: Scenario(name: 'create_pin_timeout'),
      ),
      generateDeviceBuilder(
        widget: createPinFactory(title: Stubs.title, isPinCreated: true),
        scenario: Scenario(name: 'create_pin_created'),
      ),
      generateDeviceBuilder(
        widget: createPinFactory(title: Stubs.title, deleteStoredPinData: true),
        scenario: Scenario(name: 'create_pin_data_deleted'),
      ),
    ],
    matcherCustomPump: (tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 2));
    },
  );
}
