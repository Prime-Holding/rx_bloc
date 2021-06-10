import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:{{project_name}}/feature_counter/blocs/counter_bloc.dart';
import 'package:{{project_name}}/feature_counter/views/counter_page.dart';

import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../mocks/counter_bloc_mock.dart';

Widget counterPageFactory({
  String? error,
  int? count,
  bool? isLoading,
}) =>
    Provider<CounterBlocType>(
      create: (_) => counterBlocMockFactory(
        count: count,
        error: error,
        isLoading: isLoading,
      ),
      child: const CounterPage(),
    );

void main() {
  group('CounterPage golden tests', () {
    final deviceBuilders = [
      generateDeviceBuilder(
        label: 'counter',
        widget: counterPageFactory(count: 2),
        scenarios: [Scenario(name: 'Default')],
      ),
      generateDeviceBuilder(
        label: 'error',
        widget: counterPageFactory(count: 2, error: 'Test errors'),
        scenarios: [Scenario(name: 'Error scenario')],
      ),
      generateDeviceBuilder(
        label: 'loading',
        widget: counterPageFactory(count: 2, isLoading: true),
        scenarios: [Scenario(name: 'Loading scenario')],
      ),
    ];

    runGoldenTests(deviceBuilders);
  });
}
