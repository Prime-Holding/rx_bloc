import 'dart:io';

import 'package:rx_bloc_cli/src/models/ci_cd_type.dart';
import 'package:rx_bloc_cli/src/models/command_arguments/create_command_arguments.dart';
import 'package:rx_bloc_cli/src/models/configurations/auth_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/feature_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/project_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/showcase_configuration.dart';
import 'package:rx_bloc_cli/src/models/generator_arguments.dart';
import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';

final class Stub {
  Stub._();

  static const projectName = 'testapp';
  static const empty = '';
  static const invalidProjectNameCapitalLetter = 'Testapp';
  static const invalidProjectNameDigit = '1testapp';

  static const organisation = 'com.primeholding';
  static const defaultOrganisation = 'com.example';
  static const organisationName = 'primeholding';
  static const organisationDomain = 'com';
  static const invalidOrganisation = 'c.example';

  static const incorrectRealtimeCommunicationCase = 'incorrect_case';
  static const incorrectCICDTypeCase = 'incorrect_case';

  static const licenseFileName = '{{~ licence.dart }}';

  static const overwrittenLoginFiles = [
    'test/feature_login/view/goldens/dark_theme/login_empty.png',
    'test/feature_login/view/goldens/dark_theme/login_error.png',
    'test/feature_login/view/goldens/dark_theme/login_filled.png',
    'test/feature_login/view/goldens/dark_theme/login_loading.png',
    'test/feature_login/view/goldens/dark_theme/login_success.png',
    'test/feature_login/view/goldens/light_theme/login_empty.png',
    'test/feature_login/view/goldens/light_theme/login_error.png',
    'test/feature_login/view/goldens/light_theme/login_filled.png',
    'test/feature_login/view/goldens/light_theme/login_loading.png',
    'test/feature_login/view/goldens/light_theme/login_success.png'
  ];

  static Map<String, Object> get defaultValues {
    var map = <String, Object>{
      CreateCommandArguments.projectName.name: 'testapp',
    };

    for (final argument in CreateCommandArguments.values) {
      if (!argument.mandatory) {
        map[argument.name] = argument.defaultValue();
      }
    }

    return map;
  }

  static Map<String, Object> get invalidProjectNameValues =>
      Map.from(Stub.defaultValues)
        ..[CreateCommandArguments.projectName.name] = '';

  static Map<String, Object> get invalidOrganisationValues =>
      Map.from(Stub.defaultValues)
        ..[CreateCommandArguments.organisation.name] = '';

  static Map<String, Object> get invalidAuthConfigurationValues =>
      Map.from(Stub.defaultValues)
        ..[CreateCommandArguments.login.name] = false
        ..[CreateCommandArguments.socialLogins.name] = false
        ..[CreateCommandArguments.otp.name] = true;

  static Map<String, Object> get mfaEnabled => Map.from(Stub.defaultValues)
    ..[CreateCommandArguments.mfa.name] = true
    ..[CreateCommandArguments.login.name] = false
    ..[CreateCommandArguments.socialLogins.name] = false
    ..[CreateCommandArguments.otp.name] = false;

  static Map<String, Object> get changeLanguageEnabled =>
      Map.from(Stub.defaultValues)
        ..[CreateCommandArguments.changeLanguage.name] = true
        ..[CreateCommandArguments.mfa.name] = false
        ..[CreateCommandArguments.login.name] = false
        ..[CreateCommandArguments.socialLogins.name] = false
        ..[CreateCommandArguments.otp.name] = false
        ..[CreateCommandArguments.profile.name] = false;

  static Map<String, Object> get loginEnabled => Map.from(Stub.defaultValues)
    ..[CreateCommandArguments.login.name] = true
    ..[CreateCommandArguments.profile.name] = false;

  static final generatorArgumentsAllEnabled = GeneratorArguments(
    outputDirectory: Directory('some/output_directory'),
    projectConfiguration: ProjectConfiguration(
      projectName: 'testapp',
      organisation: CreateCommandArguments.organisation.defaultValue(),
    ),
    authConfiguration: AuthConfiguration(
      loginEnabled: true,
      socialLoginsEnabled: true,
      otpEnabled: true,
      pinCodeEnabled: true,
      mfaEnabled: true,
    ),
    featureConfiguration: FeatureConfiguration(
      analyticsEnabled: true,
      pushNotificationsEnabled: true,
      changeLanguageEnabled: true,
      patrolTestsEnabled: true,
      devMenuEnabled: true,
      realtimeCommunicationEnabled: true,
      cicdEnabled: true,
      cicdGithubEnabled: true,
      cicdCodemagicEnabled: true,
      profileEnabled: true,
    ),
    showcaseConfiguration: ShowcaseConfiguration(
      counterEnabled: true,
      widgetToolkitEnabled: true,
      qrScannerEnabled: true,
      deepLinkEnabled: true,
      mfaEnabled: true,
      otpEnabled: true,
    ),
  );

  static final generatorArgumentsDefault = GeneratorArguments(
    outputDirectory: Directory('some/output_directory'),
    projectConfiguration: ProjectConfiguration(
      projectName: 'testapp',
      organisation: CreateCommandArguments.organisation.defaultValue(),
    ),
    authConfiguration: AuthConfiguration(
      loginEnabled: CreateCommandArguments.login.defaultValue(),
      socialLoginsEnabled: CreateCommandArguments.socialLogins.defaultValue(),
      otpEnabled: CreateCommandArguments.otp.defaultValue(),
      pinCodeEnabled: CreateCommandArguments.pinCode.defaultValue(),
      mfaEnabled: CreateCommandArguments.mfa.defaultValue(),
    ),
    featureConfiguration: FeatureConfiguration(
      analyticsEnabled: CreateCommandArguments.analytics.defaultValue(),
      pushNotificationsEnabled: true,
      changeLanguageEnabled:
          CreateCommandArguments.changeLanguage.defaultValue(),
      patrolTestsEnabled: CreateCommandArguments.patrol.defaultValue(),
      devMenuEnabled: CreateCommandArguments.devMenu.defaultValue(),
      realtimeCommunicationEnabled:
          CreateCommandArguments.realtimeCommunication.defaultValue() !=
              RealtimeCommunicationType.none,
      cicdEnabled: CreateCommandArguments.cicd.defaultValue() != CICDType.none,
      cicdGithubEnabled:
          CreateCommandArguments.cicd.defaultValue() == CICDType.github,
      cicdCodemagicEnabled:
          CreateCommandArguments.cicd.defaultValue() == CICDType.codemagic,
      profileEnabled: CreateCommandArguments.profile.defaultValue(),
    ),
    showcaseConfiguration: ShowcaseConfiguration(
      counterEnabled: CreateCommandArguments.counter.defaultValue(),
      widgetToolkitEnabled: CreateCommandArguments.widgetToolkit.defaultValue(),
      deepLinkEnabled: CreateCommandArguments.deepLink.defaultValue(),
      qrScannerEnabled: CreateCommandArguments.qrScanner.defaultValue(),
      mfaEnabled: CreateCommandArguments.mfa.defaultValue(),
      otpEnabled: CreateCommandArguments.otp.defaultValue(),
    ),
  );
}
