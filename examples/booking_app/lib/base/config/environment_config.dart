enum EnvironmentType { local, firebase, firebaseAlgolia }

/// Environment configuration that enables you to get define and reuse
/// environment specific properties (such as API endpoints, server secrets, ...)
class EnvironmentConfig {
  const EnvironmentConfig._({
    required this.baseApiUrl,
    this.environment = EnvironmentType.local,
  });

  final EnvironmentType environment;
  final String baseApiUrl;

  /// region Environments

  static const EnvironmentConfig local = EnvironmentConfig._(
    environment: EnvironmentType.local,
    baseApiUrl: 'http://0.0.0.0:8080',
  );

  static const EnvironmentConfig firebase = EnvironmentConfig._(
    environment: EnvironmentType.firebase,
    baseApiUrl: 'http://0.0.0.0:8080',
  );

  static const EnvironmentConfig firebaseAlgolia = EnvironmentConfig._(
    environment: EnvironmentType.firebaseAlgolia,
    baseApiUrl: 'http://0.0.0.0:8080',
  );

  ///endregion
}
