import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';

import '../models/device.dart';
import 'golden_test_device_scenario.dart';
import 'scenario_builder.dart';

/// Widget that builds a [GoldenTestGroup] with a specified configuration on
/// a list of UI components, all of the same size.
/// Each UI component will be labeled with its key, if available.
class FixedSizeScenarioBuilder extends ScenarioBuilder {
  FixedSizeScenarioBuilder({
    required this.children,
    required Size size,
    required super.name,
    super.columns,
    super.key,
  }) : super(
          devices: [
            Device(
              name: name,
              size: size,
            )
          ],
          widget: Container(),
        );

  /// List of widgets to be rendered in the scenario
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GoldenTestGroup(
      columns: columns,
      children: [
        ...children.map(
          (widget) => GoldenTestDeviceScenario(
            device: devices.first,
            scenarioName: widget.key != null && widget.key is ValueKey<String>
                ? (widget.key as ValueKey<String>).value
                : name,
            child: Scaffold(body: widget),
          ),
        ),
      ],
    );
  }
}
