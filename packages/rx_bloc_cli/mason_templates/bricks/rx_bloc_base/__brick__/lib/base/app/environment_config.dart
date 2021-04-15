enum EnvironmentType { dev, staging, prod }

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
