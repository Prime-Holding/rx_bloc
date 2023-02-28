// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.


import 'dart:io';

enum EnvironmentType { development, staging, production }

/// Environment configuration that enables you to define and read
/// environment specific properties (such as API endpoints, server secrets, ...)
class EnvironmentConfig {
  /// region Environments

  const EnvironmentConfig.development()
      : environment = EnvironmentType.development,
        androidEmulatorBaseApiUrl = 'http://10.0.2.2:8080',
        iosSimulatorBaseApiUrl = 'http://0.0.0.0:8080';

  const EnvironmentConfig.staging()
      : environment = EnvironmentType.staging,
        androidEmulatorBaseApiUrl = 'http://10.0.2.2:8080',
        iosSimulatorBaseApiUrl = 'http://0.0.0.0:8080';

  const EnvironmentConfig.production()
      : environment = EnvironmentType.production,
        androidEmulatorBaseApiUrl = 'http://10.0.2.2:8080',
        iosSimulatorBaseApiUrl = 'http://0.0.0.0:8080';

  ///endregion

  final EnvironmentType environment;
  final String androidEmulatorBaseApiUrl;
  final String iosSimulatorBaseApiUrl;

  String get baseUrl =>
      Platform.isIOS ? iosSimulatorBaseApiUrl : androidEmulatorBaseApiUrl;
}
