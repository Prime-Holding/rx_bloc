part of '../commands/create_command.dart';

class _ProjectGenerationArguments {
  _ProjectGenerationArguments({
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
    required this.realtimeCommunication,
  });

  final String projectName;
  final String organisation;
  final Directory outputDirectory;

  final bool enableAnalytics;
  final bool enableChangeLanguage;
  final bool enableCounter;
  final bool enableDeeplink;
  final bool enableDevMenu;
  final bool enableLogin;
  final bool enableOtp;
  final bool enablePatrolTests;
  final bool enableSocialLogins;
  final bool enableWidgetToolkit;

  final _RealtimeCommunicationType realtimeCommunication;

  bool get hasAuthentication =>
      enableLogin || enableSocialLogins || enableOtp;

  // Whether Firebase is used in the generated project.
  // Usually `true` because Firebase is used for push notifications.
  bool get usesFirebase => enableAnalytics || true;

  bool get usesPushNotifications => true;

  bool get realtimeCommunicationEnabled =>
      realtimeCommunication != _RealtimeCommunicationType.none;

  String get organisationName =>
      organisation.substring(organisation.indexOf('.') + 1);

  String get organisationDomain =>
      organisation.substring(0, organisation.indexOf('.'));
}
