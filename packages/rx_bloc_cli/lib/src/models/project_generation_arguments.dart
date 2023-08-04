import 'dart:io';

/// Arguments used when generating the project. Derived from CLI input.
class ProjectGenerationArguments {
  /// Project generation arguments constructor
  ProjectGenerationArguments({
    required this.projectName,
    required this.organisation,
    required this.enableAnalytics,
    required this.outputDirectory,
    required this.enableCounter,
    required this.enableDeeplink,
    required this.enableWidgetToolkit,
    required this.enableLogin,
    required this.enableSocialLogins,
    required this.enableChangeLanguage,
    required this.enableDevMenu,
    required this.enableOtp,
    required this.enablePatrolTests,
    required this.hasAuthentication,
    required this.usesFirebase,
    required this.organisationName,
    required this.organisationDomain,
    required this.usesPushNotifications,
    required this.realtimeCommunicationEnabled,
  });

  /// Project name
  final String projectName;
  /// Organisation
  final String organisation;
  /// Output directory
  final Directory outputDirectory;
  /// Organisation name
  final String organisationName;
  /// Organisation domain
  final String organisationDomain;

  /// Analytics
  final bool enableAnalytics;
  /// Change language
  final bool enableChangeLanguage;
  /// Counter showcase
  final bool enableCounter;
  /// Deep links
  final bool enableDeeplink;
  /// Dev menu
  final bool enableDevMenu;
  /// Login
  final bool enableLogin;
  /// OTP
  final bool enableOtp;
  /// Patrol tests
  final bool enablePatrolTests;
  /// Social logins
  final bool enableSocialLogins;
  /// Widget toolkit showcase
  final bool enableWidgetToolkit;
  /// Authentication
  final bool hasAuthentication;
  /// Firebase
  final bool usesFirebase;
  /// Push notifications
  final bool usesPushNotifications;
  /// Real time communication
  final bool realtimeCommunicationEnabled;


}
