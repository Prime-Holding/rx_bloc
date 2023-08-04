part of '../generator_arguments_provider.dart';

class _CommunicationConfigurationProvider {
  _CommunicationConfigurationProvider(this._reader, this._logger);

  final CommandArgumentsReader _reader;
  final Logger _logger;

  _CommunicationConfiguration read() {
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

    return _CommunicationConfiguration(
      analyticsEnabled: analyticsEnabled,
      pushNotificationsEnabled: pushNotificationsEnabled,
      realtimeCommunicationEnabled: realtimeCommunicationEnabled,
      deepLinkEnabled: deepLinkEnabled,
    );
  }
}

class _CommunicationConfiguration {
  _CommunicationConfiguration({
    required this.analyticsEnabled,
    required this.pushNotificationsEnabled,
    required this.realtimeCommunicationEnabled,
    required this.deepLinkEnabled,
  });

  final bool analyticsEnabled;
  final bool pushNotificationsEnabled;
  final bool realtimeCommunicationEnabled;
  final bool deepLinkEnabled;

  bool get usesFirebase => analyticsEnabled || pushNotificationsEnabled;
}
