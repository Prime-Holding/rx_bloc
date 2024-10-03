import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:{{project_name}}/assets.dart';
import 'package:{{project_name}}/base/theme/design_system.dart';
import 'package:{{project_name}}/base/theme/{{project_name}}.dart';
import 'package:{{project_name}}/l10n/{{project_name}}_app_i18n.dart';

import 'models/labeled_device_builder.dart';
import 'models/scenario.dart';

enum Themes { light, dark }

const localizations = [
  AppI18n.delegate,
  ...GlobalMaterialLocalizations.delegates,
];

/// return a [LabeledDeviceBuilder] with a scenario rendered on all device sizes
///
/// [widget] - to be rendered in the golden master
///
/// [scenario] - [Scenario] which will be added to [DeviceBuilder]
LabeledDeviceBuilder generateDeviceBuilder({
  required Widget widget,
  required Scenario scenario,
}) {
  final deviceBuilder = LabeledDeviceBuilder(label: scenario.name)
    ..overrideDevicesForAllScenarios(
      devices: [
        Device.phone,
        Device.iphone11,
        Device.tabletPortrait,
        Device.tabletLandscape,
      ],
    )
    ..addScenario(
      widget: widget,
      name: scenario.name,
      onCreate: scenario.onCreate,
    );
  return deviceBuilder;
}

/// executes golden tests for each [LabeledDeviceBuilder] in every [theme]
///
/// [deviceBuilders] - list of [LabeledDeviceBuilder] to be pumped
///
/// [pumpFunction] (optional) - function for executing custom pumping
/// behavior instead of [pumpDeviceBuilderWithLocalizationsAndTheme]
void runGoldenTests(
    List<LabeledDeviceBuilder> deviceBuilders, {
      Future<void> Function(WidgetTester, DeviceBuilder, Themes? theme)?
      pumpFunction,
      CustomPump? matcherCustomPump,
    }) {
  for (final db in deviceBuilders) {
    //test each DeviceBuilder in both light mode and dark mode
    for (final theme in Themes.values) {
      final themeName = theme.name;
      final directory = '${themeName}_theme';

      testGoldens('$db - $themeName', (tester) async {
        pumpFunction != null
            ? await pumpFunction.call(tester, db, theme)
            : await pumpDeviceBuilderWithLocalizationsAndTheme(
          tester,
          db,
          theme: theme,
        );

        await screenMatchesGolden(
          tester,
          '$directory/$db',
          //defaults to pumpAndSettle, causing problems when testing animations
          customPump: matcherCustomPump ??
              (db.label.contains('loading')
                  ? (tester) => tester.pump(const Duration(microseconds: 300))
                  : null),
        );
      });
    }
  }
}

/// calls [pumpDeviceBuilderWithMaterialApp] with localizations we need in this
/// app, and injects an optional theme
Future<void> pumpDeviceBuilderWithLocalizationsAndTheme(
    WidgetTester tester,
    DeviceBuilder builder, {
      Themes? theme,
    }) =>
    pumpDeviceBuilderWithMaterialApp(
      tester,
      builder,
      localizations: const [
        AppI18n.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      localeOverrides: I18n.supportedLocales,
      theme: theme == Themes.light
          ? {{project_name.pascalCase()}}Theme.buildTheme(DesignSystem.light())
          : {{project_name.pascalCase()}}Theme.buildTheme(DesignSystem.dark()),
    );

/// Wraps a [DeviceBuilder] in a [materialAppWrapper] using any of the
/// parameters we specify and pumps it
///
/// [tester] - [WidgetTester] DI
///
/// [builder] - [DeviceBuilder] to be pupmped
///
/// [platform] will override Theme's platform.
///
/// [localizations] (optional) -
/// a list of [LocalizationsDelegate] that is required for this test
///
/// [navigatorObserver] (optional) -
/// an interface for observing the behavior of a [Navigator].
///
/// [localeOverrides] (optional) -
/// sets supported supportedLocales, defaults to [Locale('en')]
///
/// [theme] (optional) - Your app theme
Future<void> pumpDeviceBuilderWithMaterialApp(
    WidgetTester tester,
    DeviceBuilder builder, {
      TargetPlatform platform = TargetPlatform.android,
      Iterable<LocalizationsDelegate<dynamic>>? localizations,
      NavigatorObserver? navigatorObserver,
      Iterable<Locale>? localeOverrides,
      ThemeData? theme,
    }) async {
  await tester.pumpDeviceBuilder(
    builder,
    wrapper: materialAppWrapper(
      platform: platform,
      localizations: localizations,
      navigatorObserver: navigatorObserver,
      localeOverrides: localeOverrides,
      theme: theme,
    ),
  );
}

/// Useful for testing UI components with a set size, instead of an entire page
///
/// [surfaceSize] - size of the widget to be tested
///
/// [builder] - function that returns a [GoldenBuilder] with a color parameter
///
/// [act] (optional) - custom action to be executed after widget is built
///
/// [matcherCustomPump] (optional) - custom pump function for testing animations
void runGoldenBuilderTests(
    String testName, {
      required Size surfaceSize,
      required GoldenBuilder Function(Color) builder,
      WidgetTesterCallback? act,
      CustomPump? matcherCustomPump,
    }) {
  for (final theme in Themes.values) {
    final themeName = theme.name;
    final directory = '${themeName}_theme';
    final themeData = theme == Themes.light
        ? {{project_name.pascalCase()}}Theme.buildTheme(DesignSystem.light())
        : {{project_name.pascalCase()}}Theme.buildTheme(DesignSystem.dark());

    testGoldens('$testName - $themeName', (tester) async {
      await tester.pumpWidgetBuilder(
        builder.call(themeData.scaffoldBackgroundColor).build(),
        wrapper: materialAppWrapper(
          localizations: localizations,
          localeOverrides: I18n.supportedLocales,
          theme: themeData,
        ),
        surfaceSize: surfaceSize,
      );

      if (act != null) {
        await act.call(tester);
      }

      await screenMatchesGolden(tester, '$directory/$testName',
          customPump: matcherCustomPump);
    });
  }
}
