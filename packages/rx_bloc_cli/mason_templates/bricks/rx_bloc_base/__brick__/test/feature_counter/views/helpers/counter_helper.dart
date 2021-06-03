import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:provider/provider.dart';

import 'package:{{project_name}}/feature_counter/di/counter_dependencies.dart';
import 'package:{{project_name}}/feature_counter/views/counter_page.dart';

import '../../../helpers/golden_helper.dart';
import '../../../helpers/models/scenario.dart';

typedef CustomDeviceBuilder = DeviceBuilder Function(WidgetTester);

// these will each get generated as separate golden master files
List<CustomDeviceBuilder> customDeviceBuilders = [
  deviceBuilderWithCounterScenarios,
  deviceBuilderWithErrorScenario,
  deviceBuilderWithLoadingScenario,
];

Widget get counterWidget => Builder(
      builder: (context) => MultiProvider(
        providers: CounterDependencies.of(context).providers,
        child: const CounterPage(),
      ),
    );

//test each counter state
DeviceBuilder deviceBuilderWithCounterScenarios(WidgetTester tester) =>
//return a generated DeviceBuilder with specified widget and list of scenarios
    generateDeviceBuilder(
      counterWidget,
      scenarios: [
        Scenario(name: 'Default page'),
        Scenario(
          name: 'Tap once',
          onCreate: (scenarioWidgetKey) async {
            final finder = buttonFinder(scenarioWidgetKey, Icons.add);
            await tester.tap(finder);
          },
        ),
        Scenario(
          name: 'Tap twice',
          onCreate: (scenarioWidgetKey) async {
            final finder = buttonFinder(scenarioWidgetKey, Icons.add);
            await tester.tap(finder);
            await tester.pumpAndSettle();
            await tester.tap(finder);
          },
        ),
      ],
    );

//test error snackbar scenarioa
DeviceBuilder deviceBuilderWithErrorScenario(WidgetTester tester) =>
    generateDeviceBuilder(
      counterWidget,
      scenarios: [
        Scenario(
          name: 'Error scenario',
          onCreate: (scenarioWidgetKey) async {
            final finder = buttonFinder(scenarioWidgetKey, Icons.remove);
            await tester.tap(finder);
          },
        ),
      ],
    );

//test loading scenario (not working)
DeviceBuilder deviceBuilderWithLoadingScenario(WidgetTester tester) =>
    generateDeviceBuilder(
      counterWidget,
      scenarios: [
        Scenario(
          name: 'Loading scenario',
          onCreate: (scenarioWidgetKey) async {
            //return fakeAsync((async) async {
            //await tester.runAsync(() async {
              final finder = buttonFinder(scenarioWidgetKey, Icons.add);
              await tester.tap(finder);
              await tester.pump();
              //await tester.pumpAndSettle();
            //});
          },
        ),
      ],
    );

//finds button with specified icon
Finder buttonFinder(Key scenarioWidgetKey, IconData icon) {
  final finder = find.descendant(
    of: find.byKey(scenarioWidgetKey),
    matching: find.byIcon(icon),
  );
  expect(finder, findsOneWidget);
  return finder;
}
