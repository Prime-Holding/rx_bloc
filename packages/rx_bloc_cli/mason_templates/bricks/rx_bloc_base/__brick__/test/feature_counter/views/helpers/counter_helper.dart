import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:provider/provider.dart';

import 'package:{{project_name}}/feature_counter/blocs/counter_bloc.dart';
import 'package:{{project_name}}/feature_counter/views/counter_page.dart';

import '../../../helpers/golden_helper.dart';
import '../../../helpers/models/scenario.dart';
import '../../mocks/counter_bloc_mock.dart';

typedef CustomDeviceBuilder = DeviceBuilder Function(WidgetTester);

// these will each get generated as separate golden master files
List<CustomDeviceBuilder> customDeviceBuilders = [
  deviceBuilderWithCounterScenarios,
  deviceBuilderWithErrorScenario,
  deviceBuilderWithLoadingScenario,
];

//test each counter state
DeviceBuilder deviceBuilderWithCounterScenarios(WidgetTester tester) =>
//return a generated DeviceBuilder with specified widget and list of scenarios
    generateDeviceBuilder(
      counterPageFactory(count: 2),
      scenarios: [
        Scenario(name: 'Default'),
      ],
    );

//test error snackbar scenario
DeviceBuilder deviceBuilderWithErrorScenario(WidgetTester tester) =>
    generateDeviceBuilder(
      counterPageFactory(count: 2, error: 'Test errors'),
      scenarios: [
        Scenario(name: 'Error scenario'),
      ],
    );

//test loading animation scenario
DeviceBuilder deviceBuilderWithLoadingScenario(WidgetTester tester) =>
    generateDeviceBuilder(
      counterPageFactory(count: 2, isLoading: true),
      scenarios: [
        Scenario(name: 'Loading scenario'),
      ],
    );

Widget counterPageFactory({
  String? error,
  int? count,
  bool? isLoading,
}) =>
    Builder(
      builder: (context) => MultiProvider(
        providers: [
          Provider<CounterBlocType>(
            create: (context) => counterBlocMockFactory(
              count: count,
              error: error,
              isLoading: isLoading,
            ),
          ),
        ],
        child: const CounterPage(),
      ),
    );
