import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:rx_bloc_cli/src/models/errors/command_usage_exception.dart';

import '../extensions/arg_results_extensions.dart';
import '../extensions/object_extensions.dart';
import '../models/realtime_communication_type.dart';
import 'command_arguments.dart';

/// Defines the main interface for reading command arguments
abstract class CommandArgumentsReader {
  /// Reads a value and optionally performs validation for the value
  T read<T extends Object>(
    CommandArguments argument, {
    T Function(T)? validation,
  });
}

/// Base implementation of read without specific data source
abstract class BaseCommandArgumentsReader implements CommandArgumentsReader {
  @override
  T read<T extends Object>(
    CommandArguments argument, {
    T Function(T)? validation,
  }) {
    if (!isSupported(argument)) {
      throw CommandUsageException(
          '${argument.name} can\'t be used interactively');
    }

    switch (argument.type) {
      case ArgumentType.string:
        final value = readString(argument).cast<T>();
        return (validation != null) ? validation(value) : value;
      case ArgumentType.boolean:
        final value = readBool(argument).cast<T>();
        return (validation != null) ? validation(value) : value;
      case ArgumentType.realTimeCommunicationEnum:
        final value = readRealtimeCommunicationEnum(argument).cast<T>();
        return (validation != null) ? validation(value) : value;
    }
  }

  /// Defines whether the provided argument can be read
  bool isSupported(CommandArguments argument);

  /// Reads a String value or provides a default value
  String readString(CommandArguments argument);

  /// Reads a bool value or provides a default value
  bool readBool(CommandArguments argument);

  /// Reads a RealtimeCommunicationType value or provides a default value
  RealtimeCommunicationType readRealtimeCommunicationEnum(
      CommandArguments argument);
}

/// Concrete implementation reading arguments interactively from Logger
final class LoggerReader extends BaseCommandArgumentsReader {
  /// Constructor for LoggerReader
  LoggerReader(this._logger);

  final Logger _logger;

  @override
  bool isSupported(CommandArguments argument) => argument.prompt != null;

  @override
  String readString(CommandArguments argument) => _logger.prompt(
        argument.prompt,
        defaultValue: argument.defaultValue,
      );

  @override
  bool readBool(CommandArguments argument) => _logger.confirm(
        argument.prompt,
        defaultValue: argument.defaultValue.cast(),
      );

  @override
  RealtimeCommunicationType readRealtimeCommunicationEnum(
    CommandArguments argument,
  ) =>
      RealtimeCommunicationType.parse(_logger.prompt(
        argument.prompt,
        defaultValue: argument.defaultValue,
      ));
}

/// Concrete implementation reading arguments non-interactively from ArgResults
final class ArgResultsReader extends BaseCommandArgumentsReader {
  /// Constructor for ArgResultsReader
  ArgResultsReader(this._argResults);

  final ArgResults _argResults;

  @override
  bool isSupported(CommandArguments argument) => true;

  @override
  String readString(CommandArguments argument) => _argResults.readString(
        argument.name,
        defaultValue: argument.defaultValue.cast(),
      );

  @override
  bool readBool(CommandArguments argument) => _argResults.readBool(
        argument.name,
        defaultValue: argument.defaultValue.cast(),
      );

  @override
  RealtimeCommunicationType readRealtimeCommunicationEnum(
    CommandArguments argument,
  ) =>
      RealtimeCommunicationType.parse(_argResults.readString(
        argument.name,
        defaultValue: argument.defaultValue.toString(),
      ));
}
