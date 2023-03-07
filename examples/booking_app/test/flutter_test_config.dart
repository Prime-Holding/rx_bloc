import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
//ignore: depend_on_referenced_packages
import 'package:visibility_detector/visibility_detector.dart';

import 'helpers/booking_app_file_comparator.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async =>
    GoldenToolkit.runWithConfiguration(
      () async {
        WidgetsApp.debugAllowBannerOverride = false;
        VisibilityDetectorController.instance.updateInterval = Duration.zero;

        await loadAppFonts();
        return testMain();
      },
      config: GoldenToolkitConfiguration(
        enableRealShadows: true,
        fileNameFactory: (String name) {
          final fileName = 'goldens/$name.png';

          goldenFileComparator = BookingAppFileComparator(fileName);

          return fileName;
        },
      ),
    );
