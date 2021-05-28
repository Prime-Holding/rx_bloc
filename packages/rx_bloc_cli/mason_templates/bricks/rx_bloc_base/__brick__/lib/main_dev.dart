// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

{{#analytics}}import 'package:firebase_core/firebase_core.dart';{{/analytics}}
import 'package:flutter/material.dart';

import 'base/app/config/environment_config.dart';
import 'base/app/{{project_name}}.dart';
import 'base/utils/helpers.dart';

// ignore_for_file: avoid_void_async

/// Main entry point for the development environment
void main() async {
  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.dev/testing/ for more info.
  // enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  {{#analytics}}
  // TODO: Add Firebase credentials for dev environment for Android and iOS
  await safeRun(()=>Firebase.initializeApp());{{/analytics}}

  runApp({{#pascalCase}}{{project_name}}{{/pascalCase}}(config: EnvironmentConfig.dev));
}
