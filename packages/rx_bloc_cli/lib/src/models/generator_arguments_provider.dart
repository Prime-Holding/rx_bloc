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

    // Read onboarding and forgottenPassword once, as they are needed by both
    // auth and feature configurations
    final onboardingEnabled =
        _reader.read<bool>(CreateCommandArguments.onboarding);
    final forgottenPassword =
        _reader.read<bool>(CreateCommandArguments.forgottenPassword);

    final authConfiguration = _readAuthConfiguration(
      onboardingEnabled: onboardingEnabled,
      forgottenPassword: forgottenPassword,
    );
    final featureConfiguration = _readFeatureConfiguration(
      authConfiguration: authConfiguration,
      onboardingEnabled: onboardingEnabled,
      forgottenPassword: forgottenPassword,
    );
    final showcaseConfiguration = _readShowcaseConfiguration(
      authConfiguration,
      featureConfiguration,
    );
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

  AuthConfiguration _readAuthConfiguration({
    required bool onboardingEnabled,
    required bool forgottenPassword,
  }) {
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

    if (mfaEnabled && !otpEnabled) {
      _logger
          .warn('Otp enabled, due to Multi-Factor Authentication requirement');
      otpEnabled = true;
    }
    if (mfaEnabled && !pinCodeEnabled) {
      _logger.warn('Pin code enabled, due to MFA feature requirement');
      pinCodeEnabled = true;
    }
    if ((otpEnabled ||
            pinCodeEnabled ||
            onboardingEnabled ||
            forgottenPassword) &&
        !(loginEnabled || socialLoginsEnabled)) {
      // Modify feature flag or throw exception
      _logger.warn(
          'Login enabled, due to OTP/PIN/Onboarding/Forgotten Password feature requirement');
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

  FeatureConfiguration _readFeatureConfiguration({
    required AuthConfiguration authConfiguration,
    required bool onboardingEnabled,
    required bool forgottenPassword,
  }) {
    // Change language
    final changeLanguageEnabled =
        _reader.read<bool>(CreateCommandArguments.changeLanguage);

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

    // In-app notifications
    final inAppNotificationsEnabled =
        _reader.read<bool>(CreateCommandArguments.inAppNotifications);

    // Adjust onboarding based on forgottenPassword dependency
    var adjustedOnboardingEnabled = onboardingEnabled;
    if (forgottenPassword && !adjustedOnboardingEnabled) {
      _logger.warn(
          'Onboarding enabled, due to Forgotten Password feature requirement');
      adjustedOnboardingEnabled = true;
    }

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
      analyticsEnabled: analyticsEnabled,
      pushNotificationsEnabled: pushNotificationsEnabled,
      realtimeCommunicationEnabled: realtimeCommunicationEnabled,
      devMenuEnabled: devMenuEnabled,
      patrolTestsEnabled: patrolTestsEnabled,
      cicdEnabled: cicdEnabled,
      cicdGithubEnabled: cicdGithubEnabled,
      cicdCodemagicEnabled: cicdCodemagicEnabled,
      profileEnabled: profileEnabled,
      onboardingEnabled: adjustedOnboardingEnabled,
      forgottenPassword: forgottenPassword,
      inAppNotificationsEnabled: inAppNotificationsEnabled,
    );
  }

  /// endregion

  /// region Showcase Configuration

  ShowcaseConfiguration _readShowcaseConfiguration(
    AuthConfiguration authConfiguration,
    FeatureConfiguration featureConfiguration,
  ) {
    // Counter
    final counterEnabled = _reader.read<bool>(CreateCommandArguments.counter);

    // Deep links
    var deepLinkEnabled = _reader.read<bool>(CreateCommandArguments.deepLink);
    // Onboarding/Registration
    final onboardingEnabled = featureConfiguration.onboardingEnabled;
    if (onboardingEnabled && !deepLinkEnabled) {
      _logger.warn('Deep links enabled, due to Onboarding feature requirement');
      deepLinkEnabled = true;
    }

    // Qr Scanner
    final qrScannerEnabled =
        _reader.read<bool>(CreateCommandArguments.qrScanner);

    // Widget toolkit
    var widgetToolkitEnabled =
        _reader.read<bool>(CreateCommandArguments.widgetToolkit);

    // In-app notifications depend on widget toolkit
    if (featureConfiguration.inAppNotificationsEnabled &&
        !widgetToolkitEnabled) {
      _logger.warn(
          'Widget toolkit enabled, due to In-app notifications feature requirement');
      widgetToolkitEnabled = true;
    }

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
