part of '../generator_arguments_provider.dart';

class _DevConfigurationProvider {
  _DevConfigurationProvider(this._reader, this._logger);

  final CommandArgumentsReader _reader;
  final Logger _logger;

  _DevConfiguration read() {
    // Dev menu
    final devMenuEnabled = _reader.read<bool>(CommandArguments.devMenu);

    // Patrol tests
    final patrolTestsEnabled = _reader.read<bool>(CommandArguments.patrol);

    return _DevConfiguration(
      devMenuEnabled: devMenuEnabled,
      patrolTestsEnabled: patrolTestsEnabled,
    );
  }
}

class _DevConfiguration {
  _DevConfiguration({
    required this.devMenuEnabled,
    required this.patrolTestsEnabled,
  });

  final bool devMenuEnabled;
  final bool patrolTestsEnabled;
}
