import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:{{project_name}}/l10n/l10n.dart';

import '../../helpers/golden_helper.dart';
import 'helpers/counter_helper.dart';

enum Theme { light, dark }

void main() {
  group('CounterPage golden tests', () {
    //test each CustomDeviceBuilder in both light mode and dark mode
    for (final deviceBuilder in customDeviceBuilders) {
      runTests(deviceBuilder, Theme.light);
      runTests(deviceBuilder, Theme.dark);
    }
  });
}

void runTests(
    CustomDeviceBuilder deviceBuilder,
    Theme theme,
    ) {
  testGoldens('$theme', (tester) async {
    final builder = deviceBuilder(tester);

    await pumpDeviceBuilderWithLocalizationsAndTheme(
      tester,
      builder,
      theme: theme == Theme.dark ? ThemeData.dark() : null,
    );

    final directory = theme == Theme.light ? 'light_theme' : 'dark_theme';
    final fileName = deviceBuilder == deviceBuilderWithCounterScenarios
        ? 'counter'
        : deviceBuilder == deviceBuilderWithLoadingScenario
        ? 'loading'
        : 'error';

    await screenMatchesGolden(
      tester,
      '$directory/$fileName',
      customPump: deviceBuilder == deviceBuilderWithLoadingScenario
          ? (tester) => tester.pump(const Duration(milliseconds: 300))
          : null,
    );
  });
}

/// calls [pumpDeviceBuilderWithMaterialApp] with localizations we need in this
/// app, and injects an optional theme
Future<void> pumpDeviceBuilderWithLocalizationsAndTheme(
    WidgetTester tester,
    DeviceBuilder builder, {
      ThemeData? theme,
    }) =>
    pumpDeviceBuilderWithMaterialApp(
      tester,
      builder,
      localizations: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      localeOverrides: AppLocalizations.supportedLocales,
      theme: theme,
    );
