{{> licence.dart }}

import 'dart:io';

/// Environment configuration that enables you to define and read
/// environment specific properties (such as API endpoints, server secrets, ...)
enum EnvironmentConfig {
  development(
    androidEmulatorBaseApiUrl: 'http://10.0.2.2:8080',
    iosSimulatorBaseApiUrl: 'http://0.0.0.0:8080'),

  staging(
    androidEmulatorBaseApiUrl: 'http://10.0.2.2:8080',
    iosSimulatorBaseApiUrl: 'http://0.0.0.0:8080'),

  production(
    androidEmulatorBaseApiUrl: 'http://10.0.2.2:8080',
    iosSimulatorBaseApiUrl: 'http://0.0.0.0:8080');

  final String androidEmulatorBaseApiUrl;
  final String iosSimulatorBaseApiUrl;

  const EnvironmentConfig({
    required this.androidEmulatorBaseApiUrl,
    required this.iosSimulatorBaseApiUrl,
  });

  String get baseUrl =>
      Platform.isIOS ? iosSimulatorBaseApiUrl : androidEmulatorBaseApiUrl;

{{#enable_dev_menu}}
  static const bool enableDevMenu =
      String.fromEnvironment('ENABLE_DEV_MENU') == 'true';{{/enable_dev_menu}}
}
