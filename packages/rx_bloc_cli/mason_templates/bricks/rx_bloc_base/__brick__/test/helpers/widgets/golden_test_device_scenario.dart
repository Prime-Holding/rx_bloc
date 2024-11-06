import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';

import '../models/device.dart';

class GoldenTestDeviceScenario extends StatelessWidget {
  const GoldenTestDeviceScenario({
    required this.device,
    required this.scenarioName,
    required this.child,
    this.padding,
    super.key,
  });

  /// The [device] specification by which to render the scenario
  final Device device;

  /// The name of the scenario
  final String scenarioName;

  /// The widget to render
  final Widget child;

  /// Optional [padding] to be applied to the scenario
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => GoldenTestScenario(
        name: '$scenarioName - ${device.name}',
        child: ClipRect(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              size: device.size,
              padding: device.safeArea,
              platformBrightness: device.brightness,
              devicePixelRatio: device.devicePixelRatio,
              textScaler: TextScaler.linear(device.textScaleFactor),
            ),
            child: Container(
              height: device.size.height,
              width: device.size.width,
              padding: padding,
              child: child,
            ),
          ),
        ),
      );
}
