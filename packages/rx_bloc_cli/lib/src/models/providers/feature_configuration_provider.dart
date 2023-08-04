part of '../generator_arguments_provider.dart';

class _FeatureConfigurationProvider {
  _FeatureConfigurationProvider(this._reader, this._logger);

  final CommandArgumentsReader _reader;
  final Logger _logger;

  _FeatureConfiguration read() {
    // Change language
    final changeLanguageEnabled =
        _reader.read<bool>(CommandArguments.changeLanguage);

    // Counter
    final counterEnabled = _reader.read<bool>(CommandArguments.counter);

    // Widget toolkit
    final widgetToolkitEnabled =
        _reader.read<bool>(CommandArguments.widgetToolkit);

    return _FeatureConfiguration(
      changeLanguageEnabled: changeLanguageEnabled,
      counterEnabled: counterEnabled,
      widgetToolkitEnabled: widgetToolkitEnabled,
    );
  }
}

class _FeatureConfiguration {
  _FeatureConfiguration({
    required this.changeLanguageEnabled,
    required this.counterEnabled,
    required this.widgetToolkitEnabled,
  });

  final bool changeLanguageEnabled;
  final bool counterEnabled;
  final bool widgetToolkitEnabled;
}
