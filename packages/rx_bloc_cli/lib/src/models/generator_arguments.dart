import 'dart:io';

import 'package:rx_bloc_cli/src/models/configurations/auth_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/feature_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/project_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/showcase_configuration.dart';

/// Arguments used when generating the project. Derived from CLI input.
class GeneratorArguments
    implements
        ProjectConfiguration,
        AuthConfiguration,
        FeatureConfiguration,
        ShowcaseConfiguration {
  /// Project generation arguments constructor
  GeneratorArguments({
    required this.outputDirectory,
    required ProjectConfiguration projectConfiguration,
    required AuthConfiguration authConfiguration,
    required FeatureConfiguration featureConfiguration,
    required ShowcaseConfiguration showcaseConfiguration,
  })  : _projectConfiguration = projectConfiguration,
        _authConfiguration = authConfiguration,
        _featureConfiguration = featureConfiguration,
        _showcaseConfiguration = showcaseConfiguration;

  final ProjectConfiguration _projectConfiguration;
  final AuthConfiguration _authConfiguration;
  final FeatureConfiguration _featureConfiguration;
  final ShowcaseConfiguration _showcaseConfiguration;

  /// Output directory
  final Directory outputDirectory;

  /// region Project Configuration

  /// Project name
  @override
  String get projectName => _projectConfiguration.projectName;

  /// Organisation
  @override
  String get organisation => _projectConfiguration.organisation;

  /// Organisation name
  @override
  String get organisationName => _projectConfiguration.organisationName;

  /// Organisation domain
  @override
  String get organisationDomain => _projectConfiguration.organisationDomain;

  /// endregion

  /// region Auth Configuration

  /// Login
  @override
  bool get loginEnabled => _authConfiguration.loginEnabled;

  /// OTP
  @override
  bool get otpEnabled => _authConfiguration.otpEnabled;

  /// Pin Code
  @override
  bool get pinCodeEnabled => _authConfiguration.pinCodeEnabled;

  /// Social logins
  @override
  bool get socialLoginsEnabled => _authConfiguration.socialLoginsEnabled;

  /// Authentication
  @override
  bool get authenticationEnabled => _authConfiguration.authenticationEnabled;

  ///Multi-Factor Authentication
  @override
  bool get mfaEnabled => _authConfiguration.mfaEnabled;

  /// endregion

  /// region Feature Configuration

  /// Profile enabled
  @override
  bool get profileEnabled => _featureConfiguration.profileEnabled;

  /// Change language
  @override
  bool get changeLanguageEnabled => _featureConfiguration.changeLanguageEnabled;

  /// Remote translations
  @override
  bool get remoteTranslationsEnabled =>
      _featureConfiguration.remoteTranslationsEnabled;

  /// Push notifications
  @override
  bool get pushNotificationsEnabled =>
      _featureConfiguration.pushNotificationsEnabled;

  /// Analytics
  @override
  bool get analyticsEnabled => _featureConfiguration.analyticsEnabled;

  /// Showcase features
  @override
  bool get showcaseEnabled => _showcaseConfiguration.showcaseEnabled;

  /// Counter showcase
  @override
  bool get counterEnabled => _showcaseConfiguration.counterEnabled;

  /// Onboarding feature
  @override
  bool get onboardingEnabled => _featureConfiguration.onboardingEnabled;

  /// Forgotten pass feature
  @override
  bool get forgottenPassword => _featureConfiguration.forgottenPassword;

  /// Dev menu
  @override
  bool get devMenuEnabled => _featureConfiguration.devMenuEnabled;

  /// Patrol tests
  @override
  bool get patrolTestsEnabled => _featureConfiguration.patrolTestsEnabled;

  /// Firebase
  @override
  bool get usesFirebase => _featureConfiguration.usesFirebase;

  /// Real time communication
  @override
  bool get realtimeCommunicationEnabled =>
      _featureConfiguration.realtimeCommunicationEnabled;

  /// endregion

  /// region CI/CD

  /// CI/CD fastlane only
  @override
  bool get cicdEnabled => _featureConfiguration.cicdEnabled;

  /// CI/CD Github
  @override
  bool get cicdGithubEnabled => _featureConfiguration.cicdGithubEnabled;

  /// CI/CD Codemagic
  @override
  bool get cicdCodemagicEnabled => _featureConfiguration.cicdCodemagicEnabled;

  /// endregion

  /// region Showcase Configuration

  /// Widget toolkit showcase
  @override
  bool get widgetToolkitEnabled => _showcaseConfiguration.widgetToolkitEnabled;

  /// QrScanner showcase
  @override
  bool get qrScannerEnabled => _showcaseConfiguration.qrScannerEnabled;

  @override
  bool get deepLinkEnabled => _showcaseConfiguration.deepLinkEnabled;

  /// endregion

  /// region Other

  /// Flag indicating if the project uses OTP functionality
  bool get hasOtp =>
      _authConfiguration.otpEnabled || _featureConfiguration.onboardingEnabled;

  /// endregion
}
