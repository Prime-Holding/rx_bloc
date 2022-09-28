import 'dart:async';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
//ignore: depend_on_referenced_packages
import 'package:visibility_detector/visibility_detector.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  WidgetsApp.debugAllowBannerOverride = false;
  VisibilityDetectorController.instance.updateInterval = Duration.zero;

  await loadAppFonts();
  return testMain();
}
