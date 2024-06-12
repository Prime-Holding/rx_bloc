import 'dart:io';

import 'package:rx_bloc_cli/src/models/configurations/auth_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/feature_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/project_configuration.dart';

/// Arguments used when generating the project. Derived from CLI input.
class GeneratorArguments
    implements ProjectConfiguration, AuthConfiguration, FeatureConfiguration {
  /// Project generation arguments constructor
  GeneratorArguments({
    required this.outputDirectory,
    required ProjectConfiguration projectConfiguration,
    required AuthConfiguration authConfiguration,
    required FeatureConfiguration featureConfiguration,
  })  : _projectConfiguration = projectConfiguration,
        _authConfiguration = authConfiguration,
        _featureConfiguration = featureConfiguration;

  final ProjectConfiguration _projectConfiguration;
  final AuthConfiguration _authConfiguration;
  final FeatureConfiguration _featureConfiguration;

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

  ///Auth matrix
  @override
  bool get authMatrixEnabled => _authConfiguration.authMatrixEnabled;

  /// endregion

  /// region Feature Configuration

  /// Analytics
  @override
  bool get analyticsEnabled => _featureConfiguration.analyticsEnabled;

  /// Change language
  @override
  bool get changeLanguageEnabled => _featureConfiguration.changeLanguageEnabled;

  /// Counter showcase
  @override
  bool get counterEnabled => _featureConfiguration.counterEnabled;

  /// Deep links
  @override
  bool get deepLinkEnabled => _featureConfiguration.deepLinkEnabled;

  /// Dev menu
  @override
  bool get devMenuEnabled => _featureConfiguration.devMenuEnabled;

  /// Patrol tests
  @override
  bool get patrolTestsEnabled => _featureConfiguration.patrolTestsEnabled;

  /// Widget toolkit showcase
  @override
  bool get widgetToolkitEnabled => _featureConfiguration.widgetToolkitEnabled;

  /// Firebase
  @override
  bool get usesFirebase => _featureConfiguration.usesFirebase;

  /// Push notifications
  @override
  bool get pushNotificationsEnabled =>
      _featureConfiguration.pushNotificationsEnabled;

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
}
