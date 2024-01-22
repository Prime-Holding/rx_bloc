// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

/// Enum containing all the possible environments
enum EnvironmentType { dev, staging, prod }

/// Environment configuration that enables you to get define and reuse
/// environment specific properties (such as API endpoints, server secrets, ...)
class EnvironmentConfig {
  const EnvironmentConfig._({
    required this.baseApiUrl,
    this.environment = EnvironmentType.dev,
  });

  /// The current environment
  final EnvironmentType environment;

  /// The base API URL
  final String baseApiUrl;

  /// region Environments

  /// The development environment
  static const EnvironmentConfig dev = EnvironmentConfig._(
    environment: EnvironmentType.dev,
    baseApiUrl: 'http://0.0.0.0:8080',
  );

  /// The staging environment
  static const EnvironmentConfig staging = EnvironmentConfig._(
    environment: EnvironmentType.staging,
    baseApiUrl: 'http://0.0.0.0:8080',
  );

  /// The production environment
  static const EnvironmentConfig prod = EnvironmentConfig._(
    environment: EnvironmentType.prod,
    baseApiUrl: 'http://0.0.0.0:8080',
  );

  ///endregion
}
