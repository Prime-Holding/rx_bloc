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
        builder: () => scenario.widget,
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


/////////// OLD CODE ///////////

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
