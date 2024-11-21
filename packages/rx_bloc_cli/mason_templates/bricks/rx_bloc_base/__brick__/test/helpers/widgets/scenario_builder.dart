import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../enums/golden_alignment.dart';
import '../models/device.dart';
import 'golden_test_device_scenario.dart';

/// Widget that builds a [GoldenTestGroup] with a specified configuration on
/// a list of devices
class ScenarioBuilder extends StatelessWidget {
  const ScenarioBuilder({
    required this.name,
    required this.builder,
    required this.devices,
    this.scenarioPadding,
    this.columns,
    this.customPumpBeforeTest,
    this.goldenAlignment = GoldenAlignment.top,
    this.act,
    super.key,
  });

  /// Name of the scenario
  final String name;

  /// Widget to be used for a golden test
  final Widget Function() builder;

  /// List of devices to render the scenario on
  final List<Device> devices;

  /// Padding to be applied to individual scenarios
  final EdgeInsets? scenarioPadding;

  /// The number of columns in the resulting golden image. If left unset,
  /// the number of columns will be calculated based on the number of children.
  final int? columns;

  /// The alignment of the scenario within the resulting layout
  final GoldenAlignment goldenAlignment;

  /// A custom pump method that will be called before each test
  final Future<void> Function(WidgetTester)? customPumpBeforeTest;

  /// A custom pump method that will be called after each test
  final WidgetTesterCallback? act;

  @override
  Widget build(BuildContext context) => GoldenTestGroup(
        columns: columns,
        children: [
          ...devices.map(
            (device) => TableCell(
              verticalAlignment: goldenAlignment.asCellAlignment(),
              child: GoldenTestDeviceScenario(
                device: device,
                scenarioName: name,
                padding: scenarioPadding,
                child: Scaffold(body: builder.call()),
              ),
            ),
          )
        ],
      );
}
