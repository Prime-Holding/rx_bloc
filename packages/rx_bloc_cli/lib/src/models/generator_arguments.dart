import 'dart:io';

/// Arguments used when generating the project. Derived from CLI input.
class GeneratorArguments {
  /// Project generation arguments constructor
  GeneratorArguments({
    required this.projectName,
    required this.organisation,
    required this.analyticsEnabled,
    required this.outputDirectory,
    required this.counterEnabled,
    required this.deeplinksEnabled,
    required this.widgetToolkitEnabled,
    required this.loginEnabled,
    required this.socialLoginsEnabled,
    required this.changeLanguageEnabled,
    required this.devMenuEnabled,
    required this.otpEnabled,
    required this.patrolTestsEnabled,
    required this.hasAuthentication,
    required this.usesFirebase,
    required this.organisationName,
    required this.organisationDomain,
    required this.pushNotificationsEnabled,
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
  final bool analyticsEnabled;
  /// Change language
  final bool changeLanguageEnabled;
  /// Counter showcase
  final bool counterEnabled;
  /// Deep links
  final bool deeplinksEnabled;
  /// Dev menu
  final bool devMenuEnabled;
  /// Login
  final bool loginEnabled;
  /// OTP
  final bool otpEnabled;
  /// Patrol tests
  final bool patrolTestsEnabled;
  /// Social logins
  final bool socialLoginsEnabled;
  /// Widget toolkit showcase
  final bool widgetToolkitEnabled;
  /// Authentication
  final bool hasAuthentication;
  /// Firebase
  final bool usesFirebase;
  /// Push notifications
  final bool pushNotificationsEnabled;
  /// Real time communication
  final bool realtimeCommunicationEnabled;
}
