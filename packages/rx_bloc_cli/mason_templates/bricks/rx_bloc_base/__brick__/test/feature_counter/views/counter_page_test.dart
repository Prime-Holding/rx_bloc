import 'package:flutter_test/flutter_test.dart';

import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import 'factories/counter_page_factory.dart';

void main() {
  group('CounterPage golden tests', () {
    final deviceBuilders = [
      generateDeviceBuilder(
        label: 'counter',
        widget: counterPageFactory(count: 2),
        scenario: Scenario(name: 'Default'),
      ),
      generateDeviceBuilder(
        label: 'error',
        widget: counterPageFactory(count: 2, error: 'Test errors'),
        scenario: Scenario(name: 'Error scenario'),
      ),
      generateDeviceBuilder(
        label: 'loading',
        widget: counterPageFactory(count: 2, isLoading: true),
        scenario: Scenario(name: 'Loading scenario'),
      ),
    ];

    runGoldenTests(deviceBuilders);
  });
}
