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
    ],
    matcherCustomPump: (tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 2));
    },
  );
}
