import 'package:flutter/material.dart';
//ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'models/labeled_device_builder.dart';
import 'models/scenario.dart';

enum Themes { light, dark }

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
          tester, '$directory/$db',
          autoHeight: true,
          //defaults to pumpAndSettle, causing problems when testing animations
          customPump: (tester) async =>
              await tester.pump(const Duration(seconds: 3)),
        );
      });
    }
  }
}

void runGoldenBuilderTests(
  String testName, {
  required Size surfaceSize,
  required GoldenBuilder builder,
  WidgetTesterCallback? act,
  CustomPump? matcherCustomPump,
}) {
  for (final theme in Themes.values) {
    final themeName = theme.name;
    final directory = '${themeName}_theme';

    testGoldens('$testName - $themeName', (tester) async {
      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: materialAppWrapper(
          // localizations: [
          //   ...GlobalMaterialLocalizations.delegates,
          // ],
          theme: theme == Themes.light
              ? ThemeData.light().copyWith(
                  extensions: <ThemeExtension<dynamic>>[],
                )
              : ThemeData.dark().copyWith(
                  extensions: <ThemeExtension<dynamic>>[],
                ),
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
      // localizations: const [
      //   ProI18n.delegate,
      //   ...GlobalMaterialLocalizations.delegates,
      // ],
      // localeOverrides: I18n.supportedLocales,
      // theme: theme == Themes.light
      //     ? DesignSystem.fromBrightness(Brightness.light).theme
      //     : DesignSystem.fromBrightness(Brightness.dark).theme,
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
