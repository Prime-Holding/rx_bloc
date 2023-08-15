import 'package:mason/mason.dart';

import '../command_arguments.dart';
import '../realtime_communication_type.dart';
import 'command_arguments_reader.dart';

/// Concrete implementation reading arguments interactively from Logger
final class InteractiveArgumentsReader extends BaseCommandArgumentsReader {
  /// Constructor for InteractiveArgumentsReader
  InteractiveArgumentsReader(this._logger);

  final Logger _logger;

  @override
  bool isSupported(CommandArguments argument) =>
      argument.supportsInteractiveInput;

  @override
  String readString(CommandArguments argument) => _logger.prompt(
        argument.prompt,
        defaultValue: argument.defaultsTo,
      );

  @override
  bool readBool(CommandArguments argument) => argument.mandatory
      ? _logger.confirm(argument.prompt)
      : _logger.confirm(argument.prompt, defaultValue: argument.defaultValue());

  @override
  RealtimeCommunicationType readRealtimeCommunicationEnum(
    CommandArguments argument,
  ) =>
      RealtimeCommunicationType.parse(_logger.prompt(
        '${argument.prompt} [ ${_rtcSupportedOptions()} ]',
        defaultValue: argument.defaultsTo,
      ));
}

/// Utility method for converting RealtimeCommunicationType options to prompt
String _rtcSupportedOptions() => RealtimeCommunicationType.supportedOptions
    .map((e) => e.toString())
    .join(' | ');
