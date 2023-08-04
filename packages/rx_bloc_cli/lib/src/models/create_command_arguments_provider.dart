import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rx_bloc_cli/src/models/project_generation_arguments.dart';
import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';

import 'command_arguments.dart';
import 'command_arguments_reader.dart';

/// The class responsible for transforming command arguments
/// to arguments that contain all the necessary data for project generation.
class ProjectGenerationArgumentsProvider {
  /// ProjectGenerationArgumentsProvider Constructor
  const ProjectGenerationArgumentsProvider(
    this._outputDirectory,
    this._logger,
    this._reader,
  );

  final Directory _outputDirectory;
  final Logger _logger;
  final CommandArgumentsReader _reader;

  /// Reads project generation arguments from provided reader source
  /// Performs necessary input validations
  ProjectGenerationArguments readProjectGenerationArguments() {
    final metadata = _ProjectMetadata.read(_reader);
    final features = _FeatureFlags.read(_reader);

    return ProjectGenerationArguments(
      outputDirectory: _outputDirectory,
      projectName: metadata.projectName,
      organisation: metadata.organisation,
      organisationName: metadata.organisationName,
      organisationDomain: metadata.organisationDomain,
      enableLogin: features.loginEnabled,
      enableSocialLogins: features.socialLoginsEnabled,
      enableOtp: features.otpEnabled,
      hasAuthentication: features.authenticationEnabled,
      enableAnalytics: features.analyticsEnabled,
      enableDeeplink: features.deepLinkEnabled,
      enableChangeLanguage: features.changeLanguageEnabled,
      enableDevMenu: features.devMenuEnabled,
      usesPushNotifications: features.pushNotificationsEnabled,
      usesFirebase: features.usesFirebase,
      realtimeCommunicationEnabled: features.realtimeCommunicationEnabled,
      enablePatrolTests: features.patrolTestsEnabled,
      enableCounter: features.counterShowcaseEnabled,
      enableWidgetToolkit: features.widgetToolkitShowcaseEnabled,
    );
  }
}

class _ProjectMetadata {
  _ProjectMetadata._(
    this.projectName,
    this.organisation,
    this.organisationName,
    this.organisationDomain,
  );

  factory _ProjectMetadata.read(CommandArgumentsReader reader) {
    final projectName = reader.read(
      CommandArguments.projectName,
      validation: _validateProjectName,
    );

    final organisation = reader.read(
      CommandArguments.organisation,
      validation: _validateOrganisation,
    );

    final organisationName =
        organisation.substring(organisation.indexOf('.') + 1);

    final organisationDomain =
        organisation.substring(0, organisation.indexOf('.'));

    return _ProjectMetadata._(
        projectName, organisation, organisationName, organisationDomain);
  }

  final String projectName;
  final String organisation;
  final String organisationName;
  final String organisationDomain;

  static String _validateProjectName(String name) {
    final regex = '[a-z_][a-z0-9_]*';
    if (!name.matches(regex: regex)) {
      throw Exception(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
      );
    }
    return name;
  }

  static String _validateOrganisation(String orgName) {
    final regex = '^([A-Za-z]{2,6})(\\.(?!-)[A-Za-z0-9-]{1,63}(?<!-))+\$';
    if (orgName.trim().isEmpty) {
      throw Exception('No organisation name specified.');
    }
    if (!orgName.matches(regex: regex)) {
      throw Exception('Invalid organisation name.');
    }
    return orgName;
  }
}

class _FeatureFlags {
  _FeatureFlags._(
    this.loginEnabled,
    this.socialLoginsEnabled,
    this.otpEnabled,
    this.authenticationEnabled,
    this.analyticsEnabled,
    this.deepLinkEnabled,
    this.changeLanguageEnabled,
    this.devMenuEnabled,
    this.pushNotificationsEnabled,
    this.realtimeCommunicationEnabled,
    this.patrolTestsEnabled,
    this.counterShowcaseEnabled,
    this.widgetToolkitShowcaseEnabled,
    this.usesFirebase,
  );

  factory _FeatureFlags.read(CommandArgumentsReader reader) {
    var loginEnabled = reader.read<bool>(CommandArguments.login);
    final socialLoginsEnabled =
        reader.read<bool>(CommandArguments.socialLogins);
    final otpEnabled = reader.read<bool>(CommandArguments.otp);

    if (otpEnabled && !(loginEnabled || socialLoginsEnabled)) {
      // logger.info('You need a login in order to use OTP authentication'); // TODO: Add
      loginEnabled = true;
    }

    final authenticationEnabled =
        loginEnabled || socialLoginsEnabled || otpEnabled;
    // Whether Firebase is used in the generated project.
    // Usually `true` because Firebase is used for push notifications.
    final analyticsEnabled = reader.read<bool>(CommandArguments.analytics);
    final usesFirebase = analyticsEnabled || true;

    // Push notifications
    final pushNotificationsEnabled = true;

    final realtimeCommunication = reader.read<RealtimeCommunicationType>(
        CommandArguments.realtimeCommunication);
    final realtimeCommunicationEnabled =
        realtimeCommunication != RealtimeCommunicationType.none;

    final deepLinkEnabled = reader.read<bool>(CommandArguments.deepLink);
    final changeLanguageEnabled =
        reader.read<bool>(CommandArguments.changeLanguage);
    final devMenuEnabled = reader.read<bool>(CommandArguments.devMenu);
    final patrolTestsEnabled = reader.read<bool>(CommandArguments.patrol);
    final counterShowcaseEnabled = reader.read<bool>(CommandArguments.counter);
    final widgetToolkitShowcaseEnabled =
        reader.read<bool>(CommandArguments.widgetToolkit);

    return _FeatureFlags._(
      loginEnabled,
      socialLoginsEnabled,
      otpEnabled,
      authenticationEnabled,
      analyticsEnabled,
      deepLinkEnabled,
      changeLanguageEnabled,
      devMenuEnabled,
      pushNotificationsEnabled,
      realtimeCommunicationEnabled,
      patrolTestsEnabled,
      counterShowcaseEnabled,
      widgetToolkitShowcaseEnabled,
      usesFirebase,
    );
  }

  final bool loginEnabled;
  final bool socialLoginsEnabled;
  final bool otpEnabled;
  final bool authenticationEnabled;
  final bool analyticsEnabled;
  final bool deepLinkEnabled;
  final bool changeLanguageEnabled;
  final bool devMenuEnabled;
  final bool pushNotificationsEnabled;
  final bool realtimeCommunicationEnabled;
  final bool patrolTestsEnabled;
  final bool counterShowcaseEnabled;
  final bool widgetToolkitShowcaseEnabled;
  final bool usesFirebase;
}

extension _StringMatchesRegex on String {
  /// Check if string matches a provided regex
  bool matches({required String regex}) {
    final regExp = RegExp(regex);
    final match = regExp.matchAsPrefix(this);
    return match != null && match.end == length;
  }
}
