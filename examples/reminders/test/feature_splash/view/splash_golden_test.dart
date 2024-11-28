import 'package:flutter_test/flutter_test.dart';

import '../../helpers/golden_helper.dart';
import '../../stubs.dart';
import '../factory/splash_factory.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  runGoldenTests([
    buildScenario(
        widget: splashFactory(), //example:  Stubs.success
        scenario: 'splash_success'),
    buildScenario(
        widget: splashFactory(isLoading: true), //loading
        scenario: 'splash_loading',
        customPumpBeforeTest: (tester) =>
            tester.pump(const Duration(microseconds: 300))),
    buildScenario(
        widget: splashFactory(errors: Stubs.errorNoConnection),
        scenario: 'splash_error')
  ]);
}
