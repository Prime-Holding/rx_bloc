import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';

import '../models/device.dart';

class GoldenTestDeviceScenario extends StatelessWidget {
  const GoldenTestDeviceScenario({
    required this.device,
    required this.scenarioName,
    required this.child,
    super.key,
  });

  final Device device;
  final String scenarioName;
  final Widget child;

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
            child: SizedBox(
              height: device.size.height,
              width: device.size.width,
              child: child,
            ),
          ),
        ),
      );
}
