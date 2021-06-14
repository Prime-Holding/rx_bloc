import 'package:flutter_test/flutter_test.dart';

import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import 'factories/counter_page_factory.dart';

void main() {
  group('CounterPage golden tests', () {
    final deviceBuilders = [
      generateDeviceBuilder(
        scenario: Scenario(name: 'counter'),
        widget: counterPageFactory(count: 2),
      ),
      generateDeviceBuilder(
        scenario: Scenario(name: 'error'),
        widget: counterPageFactory(count: 2, error: 'Test errors'),
      ),
      generateDeviceBuilder(
        scenario: Scenario(name: 'loading'),
        widget: counterPageFactory(count: 2, isLoading: true),
      ),
    ];

    runGoldenTests(deviceBuilders);
  });
}
