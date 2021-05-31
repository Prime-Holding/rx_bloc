import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:provider/provider.dart';

import 'package:{{project_name}}/l10n/l10n.dart';
import 'package:{{project_name}}/feature_counter/di/counter_dependencies.dart';
import 'package:{{project_name}}/feature_counter/views/counter_page.dart';

import '../../helpers/golden_helper.dart';

void main() {
  group('CounterPage golden tests', () {
    testGoldens('Light theme', (tester) async {
      final counterBuilder = deviceBuilderWithScenarios(tester, counterWidget);

      await pumpDeviceBuilderWithLocalizationsAndTheme(tester, counterBuilder);

      await screenMatchesGolden(
        tester,
        'counter_light',
      );
    });

    testGoldens('Dark theme', (tester) async {
      final counterBuilder = deviceBuilderWithScenarios(tester, counterWidget);

      await pumpDeviceBuilderWithLocalizationsAndTheme(tester, counterBuilder,
          theme: ThemeData.dark());

      await screenMatchesGolden(
        tester,
        'counter_dark',
        // customPump: (tester) => tester.pumpAndSettle(
        //   const Duration(milliseconds: 900),
        //   EnginePhase.sendSemanticsUpdate,
        //   const Duration(seconds: 2),
        // ),
      );
    });
  });
}

Widget get counterWidget => Builder(
      builder: (context) => MultiProvider(
        providers: CounterDependencies.of(context).providers,
        child: const CounterPage(),
      ),
    );

DeviceBuilder deviceBuilderWithScenarios(WidgetTester tester, Widget widget) =>
    defaultDeviceBuilder(tester, widget)
      ..addScenario(
        name: 'Tap once',
        widget: widget,
        onCreate: (scenarioWidgetKey) async {
          final finder = find.descendant(
            of: find.byKey(scenarioWidgetKey),
            matching: find.byIcon(Icons.add),
          );
          expect(finder, findsOneWidget);
          await tester.tap(finder);
        },
      )
      ..addScenario(
        name: 'Tap twice',
        widget: widget,
        onCreate: (scenarioWidgetKey) async {
          final finder = find.descendant(
            of: find.byKey(scenarioWidgetKey),
            matching: find.byIcon(Icons.add),
          );
          expect(finder, findsOneWidget);
          await tester.tap(finder);
          //await Future.delayed(const Duration(milliseconds: 900));
          //await tester.tap(finder);
        },
      );

Future<void> pumpDeviceBuilderWithLocalizationsAndTheme(
  WidgetTester tester,
  DeviceBuilder deviceBuilder, {
  ThemeData? theme,
}) =>
    pumpDeviceBuilderWithMaterialApp(
      tester,
      deviceBuilder,
      localizations: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      localeOverrides: AppLocalizations.supportedLocales,
      theme: theme,
    );
