import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rx_bloc_cli/src/models/configurations/auth_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/feature_configuration.dart';
import 'package:rx_bloc_cli/src/models/generator_arguments.dart';
import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';

import 'command_arguments.dart';
import 'configurations/project_configuration.dart';
import 'readers/command_arguments_reader.dart';

/// The class responsible for transforming command arguments
/// to arguments that contain all the necessary data for project generation.
class GeneratorArgumentsProvider {
  /// Constructor with output directory, reader an logger parameters
  GeneratorArgumentsProvider(
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
    final projectConfiguration = _readProjectConfiguration();
    final authConfiguration = _readAuthConfiguration();
    final featureConfiguration = _readFeatureConfiguration();

    return GeneratorArguments(
      outputDirectory: _outputDirectory,
      projectConfiguration: projectConfiguration,
      authConfiguration: authConfiguration,
      featureConfiguration: featureConfiguration,
    );
  }

  /// region Project Configuration

  ProjectConfiguration _readProjectConfiguration() {
    // Project name
    final projectName = _reader.read<String>(
      CommandArguments.projectName,
      validation: ProjectConfigurationValidations.validateProjectName,
    );

    // Organisation
    final organisation = _reader.read(
      CommandArguments.organisation,
      validation: ProjectConfigurationValidations.validateOrganisation,
    );

    return ProjectConfiguration(
      projectName: projectName,
      organisation: organisation,
    );
  }

  /// endregion

  /// region Auth Configuration

  AuthConfiguration _readAuthConfiguration() {
    // Login
    var loginEnabled = _reader.read<bool>(CommandArguments.login);

    // Social Logins
    final socialLoginsEnabled =
        _reader.read<bool>(CommandArguments.socialLogins);

    // OTP
    final otpEnabled = _reader.read<bool>(CommandArguments.otp);

    if (otpEnabled && !(loginEnabled || socialLoginsEnabled)) {
      // Modify feature flag or throw exception
      _logger.warn('Login enabled, due to OTP feature requirement');
      loginEnabled = true;
    }

    return AuthConfiguration(
      loginEnabled: loginEnabled,
      socialLoginsEnabled: socialLoginsEnabled,
      otpEnabled: otpEnabled,
    );
  }

  /// endregion

  /// region Feature Configuration

  FeatureConfiguration _readFeatureConfiguration() {
    // Change language
    final changeLanguageEnabled =
        _reader.read<bool>(CommandArguments.changeLanguage);

    // Counter
    final counterEnabled = _reader.read<bool>(CommandArguments.counter);

    // Widget toolkit
    final widgetToolkitEnabled =
        _reader.read<bool>(CommandArguments.widgetToolkit);

    // Analytics, Push Notifications, Firebase
    final analyticsEnabled = _reader.read<bool>(CommandArguments.analytics);
    final pushNotificationsEnabled = true;

    // Realtime communication
    final realtimeCommunication = _reader.read<RealtimeCommunicationType>(
        CommandArguments.realtimeCommunication);
    final realtimeCommunicationEnabled =
        realtimeCommunication != RealtimeCommunicationType.none;

    // Deep links
    final deepLinkEnabled = _reader.read<bool>(CommandArguments.deepLink);

    // Dev menu
    final devMenuEnabled = _reader.read<bool>(CommandArguments.devMenu);

    // Patrol tests
    final patrolTestsEnabled = _reader.read<bool>(CommandArguments.patrol);

    // Auth matrix
    final authMatrixEnabled = _reader.read<bool>(CommandArguments.patrol);

    return FeatureConfiguration(
      changeLanguageEnabled: changeLanguageEnabled,
      counterEnabled: counterEnabled,
      widgetToolkitEnabled: widgetToolkitEnabled,
      analyticsEnabled: analyticsEnabled,
      pushNotificationsEnabled: pushNotificationsEnabled,
      realtimeCommunicationEnabled: realtimeCommunicationEnabled,
      deepLinkEnabled: deepLinkEnabled,
      devMenuEnabled: devMenuEnabled,
      patrolTestsEnabled: patrolTestsEnabled,
      authMatrixEnabled: authMatrixEnabled,
    );
  }

  /// endregion
}
