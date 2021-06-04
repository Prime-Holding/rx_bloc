import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:provider/provider.dart';
import 'package:{{project_name}}/feature_counter/blocs/counter_bloc.dart';

import 'package:{{project_name}}/feature_counter/views/counter_page.dart';

import '../../../helpers/golden_helper.dart';
import '../../../helpers/models/scenario.dart';
import '../../blocs/counter_bloc_mock.dart';

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

//test error snackbar scenarioa
DeviceBuilder deviceBuilderWithErrorScenario(WidgetTester tester) =>
    generateDeviceBuilder(
      counterPageFactory(count: 2, error: 'Test errors'),
      scenarios: [
        Scenario(name: 'Error scenario'),
      ],
    );

//test loading scenario (not working)
DeviceBuilder deviceBuilderWithLoadingScenario(WidgetTester tester) =>
    generateDeviceBuilder(
      counterPageFactory(count: 2, isLoading: true),
      scenarios: [
        Scenario(name: 'Loading scenario'),
      ],
    );

Widget counterPageFactory({String? error, int? count, bool? isLoading}) {
  final counterBloc = CounterBlocMock()
    ..setStates(
      isLoading: isLoading,
      error: error,
      count: count,
    );

  final providers = [
    Provider<CounterBlocType>(
      create: (context) => counterBloc,
    ),
  ];

  return Builder(
    builder: (context) => MultiProvider(
      providers: providers,
      child: const CounterPage(),
    ),
  );
}
