// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

enum EnvironmentType { dev, staging, prod }

/// Environment configuration that enables you to get define and reuse
/// environment specific properties (such as API endpoints, server secrets, ...)
class EnvironmentConfig {
  const EnvironmentConfig._({
    this.environment = EnvironmentType.dev,
  });

  final EnvironmentType environment;

  /// region Environments

  static const EnvironmentConfig dev = EnvironmentConfig._(
    environment: EnvironmentType.dev,
  );

  static const EnvironmentConfig staging = EnvironmentConfig._(
    environment: EnvironmentType.staging,
  );

  static const EnvironmentConfig prod = EnvironmentConfig._(
    environment: EnvironmentType.prod,
  );

  ///endregion
}
