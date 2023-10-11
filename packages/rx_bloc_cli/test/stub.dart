import 'dart:io';

import 'package:rx_bloc_cli/src/models/ci_cd_type.dart';
import 'package:rx_bloc_cli/src/models/command_arguments.dart';
import 'package:rx_bloc_cli/src/models/configurations/auth_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/feature_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/project_configuration.dart';
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

  static const licenseFileName = '{{~ licence.dart }}';

  static Map<String, Object> get defaultValues {
    var map = <String, Object>{
      CommandArguments.projectName.name: 'testapp',
    };

    for (final argument in CommandArguments.values) {
      if (!argument.mandatory) {
        map[argument.name] = argument.defaultValue();
      }
    }

    return map;
  }

  static Map<String, Object> get invalidProjectNameValues =>
      Map.from(Stub.defaultValues)..[CommandArguments.projectName.name] = '';

  static Map<String, Object> get invalidOrganisationValues =>
      Map.from(Stub.defaultValues)..[CommandArguments.organisation.name] = '';

  static Map<String, Object> get invalidAuthConfigurationValues =>
      Map.from(Stub.defaultValues)
        ..[CommandArguments.login.name] = false
        ..[CommandArguments.socialLogins.name] = false
        ..[CommandArguments.otp.name] = true;

  static final generatorArgumentsAllEnabled = GeneratorArguments(
    outputDirectory: Directory('some/output_directory'),
    projectConfiguration: ProjectConfiguration(
      projectName: 'testapp',
      organisation: CommandArguments.organisation.defaultValue(),
    ),
    authConfiguration: AuthConfiguration(
      loginEnabled: true,
      socialLoginsEnabled: true,
      otpEnabled: true,
      pinCodeEnabled: true,
      authMatrixEnabled: true,
    ),
    featureConfiguration: FeatureConfiguration(
      analyticsEnabled: true,
      pushNotificationsEnabled: true,
      changeLanguageEnabled: true,
      counterEnabled: true,
      patrolTestsEnabled: true,
      devMenuEnabled: true,
      deepLinkEnabled: true,
      widgetToolkitEnabled: true,
      realtimeCommunicationEnabled: true,
      cicdEnabled: true,
    ),
  );

  static final generatorArgumentsDefault = GeneratorArguments(
    outputDirectory: Directory('some/output_directory'),
    projectConfiguration: ProjectConfiguration(
      projectName: 'testapp',
      organisation: CommandArguments.organisation.defaultValue(),
    ),
    authConfiguration: AuthConfiguration(
      loginEnabled: CommandArguments.login.defaultValue(),
      socialLoginsEnabled: CommandArguments.socialLogins.defaultValue(),
      otpEnabled: CommandArguments.otp.defaultValue(),
      pinCodeEnabled: CommandArguments.pinCode.defaultValue(),
      authMatrixEnabled: CommandArguments.authMatrix.defaultValue(),
    ),
    featureConfiguration: FeatureConfiguration(
      analyticsEnabled: CommandArguments.analytics.defaultValue(),
      pushNotificationsEnabled: true,
      changeLanguageEnabled: CommandArguments.changeLanguage.defaultValue(),
      counterEnabled: CommandArguments.counter.defaultValue(),
      patrolTestsEnabled: CommandArguments.patrol.defaultValue(),
      devMenuEnabled: CommandArguments.devMenu.defaultValue(),
      deepLinkEnabled: CommandArguments.deepLink.defaultValue(),
      widgetToolkitEnabled: CommandArguments.widgetToolkit.defaultValue(),
      realtimeCommunicationEnabled:
          CommandArguments.realtimeCommunication.defaultValue() !=
              RealtimeCommunicationType.none,
      cicdEnabled: CommandArguments.cicd.defaultValue() != CICDType.none,
    ),
  );
}
