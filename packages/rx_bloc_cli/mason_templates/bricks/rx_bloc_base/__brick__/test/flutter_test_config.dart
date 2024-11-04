import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/goldens_file_comparator.dart';

/// Flag indicating if the tests are running in a CI environment
/// Note: The environment variable may differ based on the platform.
// Flag indicating if the tests are running in a CI environment
/// Note: The environment variable may differ based on the platform.
bool _isRunningInCi() => [
      'CI',
      'GITHUB_ACTIONS',
      'TF_BUILD',
      'bamboo.buildKey',
      'GITLAB_CI',
      'BUILD_ID'
    ].any((tag) => bool.fromEnvironment(tag, defaultValue: false));

/// Resolves the file path for the golden image based on the name and environment
FutureOr<String> _filePathResolver(String name, String env) {
  // Resolve the theme name by removing the theme from name and placing it
  // in the correct directory
  if (name.endsWith('_light')) {
    name = 'light_theme/${name.replaceAll('_light', '')}';
  } else if (name.endsWith('_dark')) {
    name = 'dark_theme/${name.replaceAll('_dark', '')}';
  }

  final fileName = 'goldens/${env.toLowerCase()}/$name.png';
  goldenFileComparator = GoldensFileComparator(fileName);
  return fileName;
}

Future<void> testExecutable(FutureOr<void> Function() testMain) async =>
    AlchemistConfig.runWithConfig(
      config: AlchemistConfig(
        goldenTestTheme: GoldenTestTheme(
          backgroundColor: Colors.white,
          borderColor: Colors.transparent,
        ),
        platformGoldensConfig: PlatformGoldensConfig(
          enabled: !_isRunningInCi(),
          obscureText: false,
          renderShadows: true,
          filePathResolver: _filePathResolver,
        ),
        ciGoldensConfig: const CiGoldensConfig(
          obscureText: false,
          renderShadows: true,
          filePathResolver: _filePathResolver,
        ),
      ),
      run: () async {
        WidgetsApp.debugAllowBannerOverride = false;
        return testMain();
      },
    );
