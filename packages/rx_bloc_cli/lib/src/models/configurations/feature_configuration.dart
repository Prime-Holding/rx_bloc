/// Feature Configuration
class FeatureConfiguration {
  /// Feature Configuration constructor
  FeatureConfiguration({
    required this.changeLanguageEnabled,
    required this.remoteTranslationsEnabled,
    required this.analyticsEnabled,
    required this.pushNotificationsEnabled,
    required this.realtimeCommunicationEnabled,
    required this.devMenuEnabled,
    required this.patrolTestsEnabled,
    required this.cicdEnabled,
    required this.cicdGithubEnabled,
    required this.cicdCodemagicEnabled,
    required this.profileEnabled,
  });

  /// Analytics
  final bool analyticsEnabled;

  /// Push notifications
  final bool pushNotificationsEnabled;

  /// Realtime communication
  final bool realtimeCommunicationEnabled;

  /// Change language
  final bool changeLanguageEnabled;

  /// Remote translations
  final bool remoteTranslationsEnabled;

  /// Dev menu
  final bool devMenuEnabled;

  /// Patrol tests
  final bool patrolTestsEnabled;

  /// Uses Firebase
  bool get usesFirebase => analyticsEnabled || pushNotificationsEnabled;

  /// CI/CD config
  final bool cicdEnabled;

  /// CI/CD Github
  final bool cicdGithubEnabled;

  /// CI/CD Codemagic
  final bool cicdCodemagicEnabled;

  /// Profile enabled
  final bool profileEnabled;
}
