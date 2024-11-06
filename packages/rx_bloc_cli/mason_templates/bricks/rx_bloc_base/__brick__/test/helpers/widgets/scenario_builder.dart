import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';

import '../models/device.dart';
import 'golden_test_device_scenario.dart';

/// Widget that builds a [GoldenTestGroup] with a specified configuration on
/// a list of devices
class ScenarioBuilder extends StatelessWidget {
  const ScenarioBuilder({
    required this.name,
    required this.widget,
    required this.devices,
    this.scenarioPadding,
    this.columns,
    super.key,
  });

  /// Name of the scenario
  final String name;

  /// Widget to be used for a golden test
  final Widget widget;

  /// List of devices to render the scenario on
  final List<Device> devices;

  /// Padding to be applied to individual scenarios
  final EdgeInsets? scenarioPadding;

  /// The number of columns in the resulting golden image. If left unset,
  /// the number of columns will be calculated based on the number of children.
  final int? columns;

  @override
  Widget build(BuildContext context) {
    return GoldenTestGroup(
      columns: columns,
      children: [
        ...devices.map(
          (device) => GoldenTestDeviceScenario(
            device: device,
            scenarioName: name,
            padding: scenarioPadding,
            child: widget,
          ),
        )
      ],
    );
  }
}
