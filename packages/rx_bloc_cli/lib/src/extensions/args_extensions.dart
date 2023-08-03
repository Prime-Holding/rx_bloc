part of '../commands/create_command.dart';

/// Adds the provided _CommandArguments as command options
extension _ArgumentHandler on ArgParser {
  void addArguments(List<_CommandArgument> arguments) {
    for (final arg in arguments) {
      addOption(
        arg.name,
        help: arg.help,
        allowed: arg.type.allowed,
        mandatory: arg.mandatory,
      );
    }
  }
}

extension _ArgResultsSpecificValues on ArgResults {
  bool get isInteractiveConfigurationEnabled => readBool(
        _CommandArgument.interactive.name,
        _CommandArgument.interactive.defaultValue.cast(),
      );

  Directory get outputDirectory {
    final args = rest;

    if (args.isEmpty) {
      throw Exception('No option specified for the output directory.');
    }
    if (args.length > 1) {
      throw Exception('Multiple output directories specified.');
    }
    return Directory(args.first);
  }

  String readString(String name, String defaultsTo) =>
      this[name] is String ? this[name] as String : defaultsTo;

  bool readBool(String name, bool defaultsTo) =>
      readString(name, defaultsTo.toString()).toLowerCase() == true.toString();
}

abstract class _CommandArgsReader {
  T read<T extends Object>(
    _CommandArgument argument, [
    T Function(T)? validate,
  ]);
}

final class _CommandArgsLogReader implements _CommandArgsReader {
  _CommandArgsLogReader(this._logger);

  final Logger _logger;

  @override
  T read<T extends Object>(
    _CommandArgument argument, [
    T Function(T)? validate,
  ]) {
    if (!argument.allowsInteractiveInput) {
      throw UnsupportedError('${argument.name} can\'t be used interactively');
    }
    switch (argument.type) {
      case _ArgumentType.string:
        final value = _readString(argument).cast<T>();
        return (validate != null) ? validate(value) : value;
      case _ArgumentType.boolean:
        final value = _readBool(argument).cast<T>();
        return (validate != null) ? validate(value) : value;
      case _ArgumentType.realTimeCommunicationEnum:
        final value = _readRealtimeCommunicationEnum(argument).cast<T>();
        return (validate != null) ? validate(value) : value;
    }
  }

  String _readString(_CommandArgument argument) => _logger.prompt(
        argument.prompt,
        defaultValue: argument.defaultValue,
      );

  bool _readBool(_CommandArgument argument) => _logger.confirm(
        argument.prompt,
        defaultValue: argument.defaultValue.cast(),
      );

  _RealtimeCommunicationType _readRealtimeCommunicationEnum(
    _CommandArgument argument,
  ) =>
      _RealtimeCommunicationType.parse(_logger.prompt(
        argument.prompt,
        defaultValue: argument.defaultValue,
      ));
}

final class _CommandArgsResultsReader implements _CommandArgsReader {
  _CommandArgsResultsReader(this._argResults);

  final ArgResults _argResults;

  @override
  T read<T extends Object>(
    _CommandArgument argument, [
    T Function(T)? validate,
  ]) {
    if (!argument.allowsInteractiveInput) {
      throw UnsupportedError('${argument.name} can\'t be used interactively');
    }
    switch (argument.type) {
      case _ArgumentType.string:
        final value = _readString(argument).cast<T>();
        return (validate != null) ? validate(value) : value;
      case _ArgumentType.boolean:
        final value = _readBool(argument).cast<T>();
        return (validate != null) ? validate(value) : value;
      case _ArgumentType.realTimeCommunicationEnum:
        final value = _readRealtimeCommunicationEnum(argument).cast<T>();
        return (validate != null) ? validate(value) : value;
    }
  }

  String _readString(_CommandArgument argument) => _argResults.readString(
        argument.name,
        argument.defaultValue.cast(),
      );

  bool _readBool(_CommandArgument argument) => _argResults.readBool(
        argument.name,
        argument.defaultValue.cast(),
      );

  _RealtimeCommunicationType _readRealtimeCommunicationEnum(
    _CommandArgument arg,
  ) {
    return _RealtimeCommunicationType.parse(_argResults.readString(
      arg.name,
      arg.defaultValue.cast(),
    ));
  }
}

extension _CastObject on Object {
  T cast<T extends Object>() => this as T;
}
