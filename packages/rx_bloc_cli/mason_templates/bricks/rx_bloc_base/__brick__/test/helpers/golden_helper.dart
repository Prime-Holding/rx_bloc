import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:{{project_name}}/assets.dart';
import 'package:{{project_name}}/base/theme/design_system.dart';
import 'package:{{project_name}}/base/theme/{{project_name}}_theme.dart';
import 'package:{{project_name}}/l10n/{{project_name}}_app_i18n.dart';

import 'models/device.dart';
import 'widgets/scenario_builder.dart';

typedef WidgetWithThemePump = Future<void> Function(
    WidgetTester, Widget, Themes? theme);

typedef WidgetTesterCallback = Future<void> Function(WidgetTester widgetTester);

enum Themes { light, dark }

const localizations = [
  AppI18n.delegate,
  ...GlobalMaterialLocalizations.delegates,
];

const _defaultDevices = [
  Device.phone,
  Device.iphone11,
  Device.tabletPortrait,
  Device.tabletLandscape,
];

/// Convenience method that builds a [ScenarioBuilder] with a scenario rendered
/// on specified devices by default
ScenarioBuilder buildScenario({
  required Widget widget,
  required String scenario,
  List<Device> devices = _defaultDevices,
  int? columns,
}) =>
    ScenarioBuilder(
      name: scenario,
      widget: widget,
      devices: devices,
      columns: columns,
    );

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
        pumpBeforeTest: scenarioName.contains('loading')
            ? (tester) => tester.pump(const Duration(milliseconds: 300))
            : onlyPumpAndSettle,
        whilePerforming:
          act != null ? (tester) async => () async => act(tester) : null,
      );
    }
  }
}

/// calls [pumpDeviceBuilderWithMaterialApp] with localizations we need in this
/// app, and injects an optional theme
Future<void> pumpDeviceBuilderWithLocalizationsAndTheme(
    WidgetTester tester,
    Widget widget, {
      Themes? theme,
    }) =>
    pumpScenarioBuilderWithMaterialApp(
        tester,
        widget,
        localizations: const [
          AppI18n.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        localeOverrides: I18n.supportedLocales,
        theme: theme == Themes.light
            ? {{project_name.pascalCase()}}Theme.buildTheme(DesignSystem.light())
            : {{project_name.pascalCase()}}Theme.buildTheme(DesignSystem.dark()),
);

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