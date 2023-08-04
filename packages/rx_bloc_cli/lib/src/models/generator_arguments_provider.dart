import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rx_bloc_cli/src/models/errors/command_usage_exception.dart';
import 'package:rx_bloc_cli/src/models/generator_arguments.dart';
import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';

import 'command_arguments.dart';
import 'command_arguments_reader.dart';

/// The class responsible for transforming command arguments
/// to arguments that contain all the necessary data for project generation.
class GeneratorArgumentsProvider {
  /// Constructor with output directory, reader an logger parameters
  const GeneratorArgumentsProvider(
    this._outputDirectory,
    this._reader,
    this._logger,
  );

  final Directory _outputDirectory;
  final CommandArgumentsReader _reader;
  final Logger _logger;

  /// Reads project generation arguments from provided reader source
  /// Performs necessary input validations
  GeneratorArguments readGeneratorArguments() {
    // Project name
    final projectName = _reader.read(
      CommandArguments.projectName,
      validation: _validateProjectName,
    );

    // Organisation
    final organisation = _reader.read(
      CommandArguments.organisation,
      validation: _validateOrganisation,
    );

    // Organisation name
    final organisationName =
        organisation.substring(organisation.indexOf('.') + 1);

    // Organisation Domain
    final organisationDomain =
        organisation.substring(0, organisation.indexOf('.'));

    // Login
    var loginEnabled = _reader.read<bool>(CommandArguments.login);

    // Social Logins
    final socialLoginsEnabled =
        _reader.read<bool>(CommandArguments.socialLogins);
    final otpEnabled = _reader.read<bool>(CommandArguments.otp);

    if (otpEnabled && !(loginEnabled || socialLoginsEnabled)) {
      // Modify feature or throw exception
      _logger.warn('Login enabled, due to OTP feature requirement');
      loginEnabled = true;
    }

    // Authentication
    final authenticationEnabled =
        loginEnabled || socialLoginsEnabled || otpEnabled;

    // Analytics, Push Notifications, Firebase
    final analyticsEnabled = _reader.read<bool>(CommandArguments.analytics);
    final pushNotificationsEnabled = true;
    final usesFirebase = true;

    // Deep links
    final deepLinkEnabled = _reader.read<bool>(CommandArguments.deepLink);

    // Change language
    final changeLanguageEnabled =
        _reader.read<bool>(CommandArguments.changeLanguage);

    // Dev menu
    final devMenuEnabled = _reader.read<bool>(CommandArguments.devMenu);

    // Patrol tests
    final patrolTestsEnabled = _reader.read<bool>(CommandArguments.patrol);

    // Counter
    final counterShowcaseEnabled = _reader.read<bool>(CommandArguments.counter);

    // Widget toolkit
    final widgetToolkitShowcaseEnabled =
        _reader.read<bool>(CommandArguments.widgetToolkit);

    // Realtime communication
    final realtimeCommunication = _reader.read<RealtimeCommunicationType>(
        CommandArguments.realtimeCommunication);
    final realtimeCommunicationEnabled =
        realtimeCommunication != RealtimeCommunicationType.none;

    return GeneratorArguments(
      outputDirectory: _outputDirectory,
      projectName: projectName,
      organisation: organisation,
      organisationName: organisationName,
      organisationDomain: organisationDomain,
      loginEnabled: loginEnabled,
      socialLoginsEnabled: socialLoginsEnabled,
      otpEnabled: otpEnabled,
      hasAuthentication: authenticationEnabled,
      analyticsEnabled: analyticsEnabled,
      deeplinksEnabled: deepLinkEnabled,
      changeLanguageEnabled: changeLanguageEnabled,
      devMenuEnabled: devMenuEnabled,
      pushNotificationsEnabled: pushNotificationsEnabled,
      usesFirebase: usesFirebase,
      realtimeCommunicationEnabled: realtimeCommunicationEnabled,
      patrolTestsEnabled: patrolTestsEnabled,
      counterEnabled: counterShowcaseEnabled,
      widgetToolkitEnabled: widgetToolkitShowcaseEnabled,
    );
  }

  static String _validateProjectName(String name) {
    final regex = '[a-z_][a-z0-9_]*';
    if (!name.matches(regex: regex)) {
      throw CommandUsageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
      );
    }
    return name;
  }

  static String _validateOrganisation(String orgName) {
    final regex = '^([A-Za-z]{2,6})(\\.(?!-)[A-Za-z0-9-]{1,63}(?<!-))+\$';
    if (orgName.trim().isEmpty) {
      throw CommandUsageException('No organisation name specified.');
    }
    if (!orgName.matches(regex: regex)) {
      throw CommandUsageException('Invalid organisation name.');
    }
    return orgName;
  }
}

extension _StringMatchesRegex on String {
  /// Check if string matches a provided regex
  bool matches({required String regex}) {
    final regExp = RegExp(regex);
    final match = regExp.matchAsPrefix(this);
    return match != null && match.end == length;
  }
}
