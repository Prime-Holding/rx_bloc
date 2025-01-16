import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rx_bloc_cli/src/models/ci_cd_type.dart';
import 'package:rx_bloc_cli/src/models/configurations/auth_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/feature_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/showcase_configuration.dart';
import 'package:rx_bloc_cli/src/models/generator_arguments.dart';
import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';

import 'command_arguments/create_command_arguments.dart';
import 'configurations/project_configuration.dart';
import 'readers/command_arguments_reader.dart';

/// The class responsible for transforming command arguments
/// to arguments that contain all the necessary data for project generation.
class GeneratorArgumentsProvider {
  /// Constructor with output directory, reader and logger parameters
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
    final featureConfiguration = _readFeatureConfiguration(authConfiguration);
    final showcaseConfiguration = _readShowcaseConfiguration(authConfiguration);
    return GeneratorArguments(
      outputDirectory: _outputDirectory,
      projectConfiguration: projectConfiguration,
      authConfiguration: authConfiguration,
      featureConfiguration: featureConfiguration,
      showcaseConfiguration: showcaseConfiguration,
    );
  }

  /// region Project Configuration

  ProjectConfiguration _readProjectConfiguration() {
    // Project name
    final projectName = _reader.read<String>(
      CreateCommandArguments.projectName,
      validation: ProjectConfigurationValidations.validateProjectName,
    );

    // Organisation
    final organisation = _reader.read(
      CreateCommandArguments.organisation,
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
    var loginEnabled = _reader.read<bool>(CreateCommandArguments.login);

    // Social Logins
    final socialLoginsEnabled =
        _reader.read<bool>(CreateCommandArguments.socialLogins);

    // OTP
    var otpEnabled = _reader.read<bool>(CreateCommandArguments.otp);

    // Pin Code
    var pinCodeEnabled = _reader.read<bool>(CreateCommandArguments.pinCode);

    // Multi-Factor Authentication
    final mfaEnabled = _reader.read<bool>(CreateCommandArguments.mfa);

    // Onboarding/Registration
    final onboardingEnabled =
        _reader.read<bool>(CreateCommandArguments.onboarding);

    if (mfaEnabled && !otpEnabled) {
      _logger
          .warn('Otp enabled, due to Multi-Factor Authentication requirement');
      otpEnabled = true;
    }
    if (mfaEnabled && !pinCodeEnabled) {
      _logger.warn('Pin code enabled, due to MFA feature requirement');
      pinCodeEnabled = true;
    }
    if ((otpEnabled || pinCodeEnabled || onboardingEnabled) &&
        !(loginEnabled || socialLoginsEnabled)) {
      // Modify feature flag or throw exception
      _logger
          .warn('Login enabled, due to OTP/PIN/Onboarding feature requirement');
      loginEnabled = true;
    }

    return AuthConfiguration(
      loginEnabled: loginEnabled,
      socialLoginsEnabled: socialLoginsEnabled,
      otpEnabled: otpEnabled,
      pinCodeEnabled: pinCodeEnabled,
      mfaEnabled: mfaEnabled,
    );
  }

  /// endregion

  /// region Feature Configuration

  FeatureConfiguration _readFeatureConfiguration(
      AuthConfiguration authConfiguration) {
    // Change language
    final changeLanguageEnabled =
        _reader.read<bool>(CreateCommandArguments.changeLanguage);

    // Remote translations
    final remoteTranslationsEnabled =
        _reader.read<bool>(CreateCommandArguments.remoteTranslations);

    // Analytics, Push Notifications, Firebase
    final analyticsEnabled =
        _reader.read<bool>(CreateCommandArguments.analytics);
    final pushNotificationsEnabled = true;

    // Realtime communication
    final realtimeCommunication = _reader.read<RealtimeCommunicationType>(
        CreateCommandArguments.realtimeCommunication);
    final realtimeCommunicationEnabled =
        realtimeCommunication != RealtimeCommunicationType.none;

    // Dev menu
    final devMenuEnabled = _reader.read<bool>(CreateCommandArguments.devMenu);

    // Patrol tests
    final patrolTestsEnabled =
        _reader.read<bool>(CreateCommandArguments.patrol);

    // CI/CD
    final cicdType = _reader.read<CICDType>(CreateCommandArguments.cicd);
    final cicdEnabled = cicdType != CICDType.none;
    final cicdGithubEnabled = cicdType == CICDType.github;
    final cicdCodemagicEnabled = cicdType == CICDType.codemagic;

    // Profile
    var profileEnabled = _reader.read<bool>(CreateCommandArguments.profile);

    // Onboarding/Registration
    final onboardingEnabled =
        _reader.read<bool>(CreateCommandArguments.onboarding);

    // Authentication
    final authenticationEnabled = authConfiguration.authenticationEnabled;
    if (authenticationEnabled && !profileEnabled) {
      _logger
          .warn('Profile enabled, due to authentication feature requirement');
      profileEnabled = true;
    }
    if (changeLanguageEnabled && !profileEnabled) {
      _logger
          .warn('Profile enabled, due to change language feature requirement');
      profileEnabled = true;
    }

    return FeatureConfiguration(
        changeLanguageEnabled: changeLanguageEnabled,
        remoteTranslationsEnabled: remoteTranslationsEnabled,
        analyticsEnabled: analyticsEnabled,
        pushNotificationsEnabled: pushNotificationsEnabled,
        realtimeCommunicationEnabled: realtimeCommunicationEnabled,
        devMenuEnabled: devMenuEnabled,
        patrolTestsEnabled: patrolTestsEnabled,
        cicdEnabled: cicdEnabled,
        cicdGithubEnabled: cicdGithubEnabled,
        cicdCodemagicEnabled: cicdCodemagicEnabled,
        profileEnabled: profileEnabled,
        onboardingEnabled: onboardingEnabled);
  }

  /// endregion

  /// region Showcase Configuration

  ShowcaseConfiguration _readShowcaseConfiguration(
      AuthConfiguration authConfiguration) {
    // Counter
    final counterEnabled = _reader.read<bool>(CreateCommandArguments.counter);

    // Deep links
    var deepLinkEnabled = _reader.read<bool>(CreateCommandArguments.deepLink);
    // Onboarding/Registration
    final onboardingEnabled =
        _reader.read<bool>(CreateCommandArguments.onboarding);
    if (onboardingEnabled && !deepLinkEnabled) {
      _logger.warn('Deep links enabled, due to Onboarding feature requirement');
      deepLinkEnabled = true;
    }

    // Qr Scanner
    final qrScannerEnabled =
        _reader.read<bool>(CreateCommandArguments.qrScanner);

    // Widget toolkit
    final widgetToolkitEnabled =
        _reader.read<bool>(CreateCommandArguments.widgetToolkit);

    return ShowcaseConfiguration(
      counterEnabled: counterEnabled,
      widgetToolkitEnabled: widgetToolkitEnabled,
      qrScannerEnabled: qrScannerEnabled,
      deepLinkEnabled: deepLinkEnabled,
      mfaEnabled: authConfiguration.mfaEnabled,
      otpEnabled: authConfiguration.otpEnabled,
    );
  }
}
