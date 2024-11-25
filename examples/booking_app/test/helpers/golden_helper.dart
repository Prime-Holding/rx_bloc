import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
//ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import 'enums/app_themes.dart';
import 'enums/golden_alignment.dart';
import 'models/device.dart';
import 'widgets/fixed_size_scenario_builder.dart';
import 'widgets/scenario_builder.dart';

/// region Type definitions

/// Type definition for a function that wraps a widget with a theme and pumps it
typedef WidgetWithThemePump = Future<void> Function(
  WidgetTester,
  Widget,
  Themes? theme,
);

/// Type definition for a function that accepts a [WidgetTester] parameter
typedef WidgetTesterCallback = Future<void> Function(WidgetTester widgetTester);

/// Default devices to run golden tests on
const _defaultDevices = [
  Device(
      name: 'iPhone SE(2nd generation)',
      size: Size(375, 667),
      safeArea: EdgeInsets.only(top: 20),
      devicePixelRatio: 2),
  Device(
    name: 'Google Pixel 4a',
    size: Size(412, 732),
  ),
  Device(
      name: 'iPhone 13 mini',
      size: Size(375, 812),
      safeArea: EdgeInsets.only(top: 44, bottom: 34),
      devicePixelRatio: 3),
  Device(
      name: 'Google Pixel 5',
      size: Size(393, 851),
      safeArea: EdgeInsets.only(top: 24, bottom: 48),
      devicePixelRatio: 2.75),
  Device(
      name: 'Samsung Galaxy S20',
      size: Size(412, 915),
      safeArea: EdgeInsets.only(top: 24, bottom: 48),
      devicePixelRatio: 3),
  Device(
      name: 'Samsung Galaxy Tab S6 Landscape',
      size: Size(1280, 800),
      safeArea: EdgeInsets.only(top: 24, bottom: 48),
      devicePixelRatio: 2),
  Device(
      name: 'Apple iPad Pro 12.9',
      size: Size(1024, 1366),
      safeArea: EdgeInsets.only(top: 24, bottom: 34),
      devicePixelRatio: 2),
];

/// endregion

/// region Builders

/// Convenience method that builds a [ScenarioBuilder] with a scenario rendered
/// on specified devices laid out in one row
ScenarioBuilder buildScenario({
  required Widget widget,
  required String scenario,
  WidgetTesterCallback? customPumpBeforeTest,
  List<Device> devices = _defaultDevices,
  EdgeInsets? scenarioPadding = const EdgeInsets.symmetric(horizontal: 4),
}) =>
    ScenarioBuilder(
      name: scenario,
      widget: widget,
      devices: devices,
      customPumpBeforeTest: customPumpBeforeTest,
      scenarioPadding: scenarioPadding,
      columns: _defaultDevices.length,
      goldenAlignment: GoldenAlignment.center,
    );

/// Convenience method that builds a [ScenarioBuilder] with a scenario rendered
/// on specified devices laid out in a grid
ScenarioBuilder buildScenarioGrid({
  required Widget widget,
  required String scenario,
  WidgetTesterCallback? customPumpBeforeTest,
  GoldenAlignment? goldenAlignment,
  int? columns,
  List<Device> devices = _defaultDevices,
  EdgeInsets? scenarioPadding = const EdgeInsets.all(4),
}) =>
    ScenarioBuilder(
      name: scenario,
      widget: widget,
      devices: devices,
      columns: columns,
      customPumpBeforeTest: customPumpBeforeTest,
      goldenAlignment: goldenAlignment ?? GoldenAlignment.top,
      scenarioPadding: scenarioPadding,
    );

/// endregion

/// region Golden test runners

/// Runs golden tests for a list of UI components in both light and dark mode,
/// all of the same size.
void runUiComponentGoldenTests({
  required List<Widget> children,
  required String scenario,
  required Size size,
  WidgetWithThemePump? customWrapAndPump,
  WidgetTesterCallback? act,
  EdgeInsets? scenarioPadding,
  GoldenAlignment? goldenAlignment,
}) {
  runGoldenTests(
    [
      FixedSizeScenarioBuilder(
        name: scenario,
        size: size,
        scenarioPadding: scenarioPadding,
        goldenAlignment: goldenAlignment ?? GoldenAlignment.top,
        children: children,
      )
    ],
    customWrapAndPump: customWrapAndPump,
    act: act,
  );
}

/// Runs golden tests for a list of scenarios in both light and dark mode
void runGoldenTests(
  List<ScenarioBuilder> buildScenarios, {
  WidgetWithThemePump? customWrapAndPump,
  WidgetTesterCallback? act,
}) {
  for (final scenario in buildScenarios) {
    for (final theme in Themes.values) {
      final themeName = theme.name;
      final scenarioName = scenario.name;

      goldenTest(
        '$scenarioName - $themeName',
        fileName: '${scenarioName}_$themeName',
        builder: () => scenario,
        pumpWidget: (tester, widget) =>
            customWrapAndPump?.call(tester, widget, theme) ??
            pumpDeviceBuilderWithLocalizationsAndTheme(
              tester,
              widget,
              theme: theme,
            ),
        pumpBeforeTest: scenario.customPumpBeforeTest ?? onlyPumpAndSettle,
        whilePerforming:
            act != null ? (tester) async => () async => act(tester) : null,
      );
    }
  }
}

/// endregion

/// region Pump helpers

/// Pumps the provided [widget] and injects a [MaterialApp] wrapper,
/// localizations and theme.
Future<void> pumpDeviceBuilderWithLocalizationsAndTheme(
  WidgetTester tester,
  Widget widget, {
  Themes? theme,
}) =>
    pumpScenarioBuilderWithMaterialApp(
      tester,
      widget,
    );

/// Pumps the provided [widget] and injects a [MaterialApp] wrapper
Future<void> pumpScenarioBuilderWithMaterialApp(
  WidgetTester tester,
  Widget widget, {
  TargetPlatform platform = TargetPlatform.android,
  Iterable<LocalizationsDelegate<dynamic>>? localizations,
  NavigatorObserver? navigatorObserver,
  Iterable<Locale>? localeOverrides,
  ThemeData? theme,
}) async {
  await onlyPumpWidget(
      tester,
      _buildMaterialAppWrapper(
        child: widget,
        platform: platform,
        localizations: localizations,
        navigatorObserver: navigatorObserver,
        localeOverrides: localeOverrides,
        theme: theme,
      ));
}

/// Wraps the provided [child] with a [MaterialApp] to ensure that the golden
/// test is run in a consistent environment.
Widget _buildMaterialAppWrapper({
  required Widget child,
  TargetPlatform platform = TargetPlatform.android,
  Iterable<LocalizationsDelegate<dynamic>>? localizations,
  NavigatorObserver? navigatorObserver,
  Iterable<Locale>? localeOverrides,
  ThemeData? theme,
}) {
  return MaterialApp(
    localizationsDelegates: localizations,
    supportedLocales: localeOverrides ?? const [Locale('en')],
    theme: theme?.copyWith(platform: platform),
    debugShowCheckedModeBanner: false,
    home: Material(child: child),
    navigatorObservers: [
      if (navigatorObserver != null) navigatorObserver,
    ],
  );
}

/// endregion
