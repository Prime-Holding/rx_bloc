part of '../generator_arguments_provider.dart';

class _FeatureConfigurationProvider {
  _FeatureConfigurationProvider(this._reader);

  final CommandArgumentsReader _reader;

  FeatureConfiguration read() {
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
    );
  }
}
