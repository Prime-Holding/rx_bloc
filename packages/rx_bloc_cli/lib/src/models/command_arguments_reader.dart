part of '../commands/create_command.dart';

/// Defines the main interface for reading command arguments
abstract class _CommandArgumentsReader {
  T read<T extends Object>(
    _CommandArgument argument, {
    T Function(T)? validation,
  });
}

/// Contains base implementation of argument reading without specific source
abstract class _BaseArgumentsReader implements _CommandArgumentsReader {
  @override
  T read<T extends Object>(
    _CommandArgument argument, {
    T Function(T)? validation,
  }) {
    final prompt = argument.prompt;
    final defaultValue = argument.defaultValue;

    if (prompt == null) {
      throw UnsupportedError('${argument.name} can\'t be used interactively');
    }

    switch (argument.type) {
      case _ArgumentType.string:
        final value = readString(prompt, defaultValue).cast<T>();
        return (validation != null) ? validation(value) : value;
      case _ArgumentType.boolean:
        final value = readBool(prompt, defaultValue).cast<T>();
        return (validation != null) ? validation(value) : value;
      case _ArgumentType.realTimeCommunicationEnum:
        final value =
            readRealtimeCommunicationEnum(prompt, defaultValue).cast<T>();
        return (validation != null) ? validation(value) : value;
    }
  }

  @override
  String readString(
    String prompt,
    Object defaultValue,
  );

  @override
  bool readBool(
    String prompt,
    Object defaultValue,
  );

  @override
  _RealtimeCommunicationType readRealtimeCommunicationEnum(
    String prompt,
    Object defaultValue,
  );
}

/// Concrete implementation reading arguments interactively from Logger
final class _LogReader extends _BaseArgumentsReader {
  _LogReader(this._logger);

  final Logger _logger;

  @override
  String readString(String prompt, Object defaultValue) => _logger.prompt(
        prompt,
        defaultValue: defaultValue,
      );

  @override
  bool readBool(String prompt, Object defaultValue) => _logger.confirm(
        prompt,
        defaultValue: defaultValue.cast(),
      );

  @override
  _RealtimeCommunicationType readRealtimeCommunicationEnum(
    String prompt,
    Object defaultValue,
  ) =>
      _RealtimeCommunicationType.parse(_logger.prompt(
        prompt,
        defaultValue: defaultValue,
      ));
}

/// Concrete implementation reading arguments non-interactively from ArgResults
final class _ArgResultsReader extends _BaseArgumentsReader {
  _ArgResultsReader(this._argResults);

  final ArgResults _argResults;

  @override
  String readString(String name, Object defaultValue) => _argResults.readString(
        name,
        defaultValue.cast(),
      );

  @override
  bool readBool(String name, Object defaultValue) => _argResults.readBool(
        name,
        defaultValue.cast(),
      );

  @override
  _RealtimeCommunicationType readRealtimeCommunicationEnum(
    String name,
    Object defaultValue,
  ) {
    return _RealtimeCommunicationType.parse(_argResults.readString(
      name,
      defaultValue.cast(),
    ));
  }
}
