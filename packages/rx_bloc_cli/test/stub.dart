import 'dart:io';

import 'package:rx_bloc_cli/src/models/command_arguments.dart';
import 'package:rx_bloc_cli/src/models/configurations/auth_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/feature_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/project_configuration.dart';

final class Stub {
  Stub._();

  static final projectConfiguration = ProjectConfiguration(
    projectName: 'testapp',
    organisation: 'com.example',
  );

  static final defaultAuthConfiguration = AuthConfiguration(
    loginEnabled: CommandArguments.login.defaultValue(),
    socialLoginsEnabled: CommandArguments.socialLogins.defaultValue(),
    otpEnabled: CommandArguments.otp.defaultValue(),
  );

  static final defaultFeatureConfiguration = FeatureConfiguration(
    changeLanguageEnabled: CommandArguments.changeLanguage.defaultValue(),
    counterEnabled: CommandArguments.changeLanguage.defaultValue(),
    widgetToolkitEnabled: CommandArguments.changeLanguage.defaultValue(),
    analyticsEnabled: CommandArguments.changeLanguage.defaultValue(),
    pushNotificationsEnabled: CommandArguments.changeLanguage.defaultValue(),
    realtimeCommunicationEnabled:
        CommandArguments.changeLanguage.defaultValue(),
    deepLinkEnabled: CommandArguments.changeLanguage.defaultValue(),
    devMenuEnabled: CommandArguments.changeLanguage.defaultValue(),
    patrolTestsEnabled: CommandArguments.changeLanguage.defaultValue(),
  );

  static final Map<String, Object> defaultValues = {
    CommandArguments.projectName.name: 'testapp',
    CommandArguments.organisation.name: 'com.example',
    CommandArguments.login.name: CommandArguments.login.defaultValue(),
    CommandArguments.socialLogins.name:
        CommandArguments.socialLogins.defaultValue(),
    CommandArguments.otp.name: CommandArguments.otp.defaultValue(),
    CommandArguments.analytics.name: CommandArguments.analytics.defaultValue(),
    CommandArguments.realtimeCommunication.name:
        CommandArguments.realtimeCommunication.defaultValue(),
    CommandArguments.interactive.name:
        CommandArguments.interactive.defaultValue(),
    CommandArguments.changeLanguage.name:
        CommandArguments.changeLanguage.defaultValue(),
    CommandArguments.widgetToolkit.name:
        CommandArguments.widgetToolkit.defaultValue(),
    CommandArguments.patrol.name: CommandArguments.patrol.defaultValue(),
    CommandArguments.devMenu.name: CommandArguments.devMenu.defaultValue(),
    CommandArguments.deepLink.name: CommandArguments.deepLink.defaultValue(),
    CommandArguments.counter.name: CommandArguments.counter.defaultValue(),
  };
}
