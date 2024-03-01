import 'package:mason/mason.dart';
import 'package:rx_bloc_cli/src/models/ci_cd_type.dart';

import '../command_arguments/create_command_arguments.dart';
import '../realtime_communication_type.dart';
import 'command_arguments_reader.dart';

/// Concrete implementation reading arguments interactively from Logger
final class InteractiveArgumentsReader extends BaseCommandArgumentsReader {
  /// Constructor for InteractiveArgumentsReader
  InteractiveArgumentsReader(this._logger);

  final Logger _logger;

  @override
  bool isSupported(CreateCommandArguments argument) =>
      argument.supportsInteractiveInput;

  @override
  String readString(CreateCommandArguments argument) {
    if (argument.type != CreateCommandArgumentType.string) {
      throw UnsupportedError(
        '"${argument.name}" can not be read as String. '
        'Please find a suitable read method for "${argument.type.name}"',
      );
    }
    return _logger.prompt(
      argument.prompt,
      defaultValue: argument.defaultsTo,
    );
  }

  @override
  bool readBool(CreateCommandArguments argument) {
    if (argument.type != CreateCommandArgumentType.boolean) {
      throw UnsupportedError(
        '"${argument.name}" can not be read as bool. '
        'Please find a suitable read method for "${argument.type.name}"',
      );
    }
    return _logger.confirm(
      argument.prompt,
      defaultValue: argument.defaultValue(),
    );
  }

  @override
  RealtimeCommunicationType readRealtimeCommunicationEnum(
    CreateCommandArguments argument,
  ) {
    if (argument.type != CreateCommandArgumentType.realTimeCommunicationEnum) {
      throw UnsupportedError(
        '"${argument.name}" can not be read as RealtimeCommunicationType. '
        'Please find a suitable read method for "${argument.type.name}"',
      );
    }
    final prompt = '${argument.prompt} [ ${_rtcSupportedOptions()} ]';
    return RealtimeCommunicationType.parse(_logger.prompt(
      prompt,
      defaultValue: argument.defaultsTo,
    ));
  }

  @override
  CICDType readCICDEnum(CreateCommandArguments argument) {
    if (argument.type != CreateCommandArgumentType.cicdTypeEnum) {
      throw UnsupportedError(
        '"${argument.name}" can not be read as CICDType. '
        'Please find a suitable read method for "${argument.type.name}"',
      );
    }
    final prompt = '${argument.prompt} [ ${_cicdSupportedOptions()} ]';
    return CICDType.parse(_logger.prompt(
      prompt,
      defaultValue: argument.defaultsTo,
    ));
  }
}

/// Utility method for converting RealtimeCommunicationType options to prompt
String _rtcSupportedOptions() => RealtimeCommunicationType.supportedOptions
    .map((e) => e.toString())
    .join(' | ');

/// Utility method for converting CICDType options to prompt
String _cicdSupportedOptions() =>
    CICDType.supportedOptions.map((e) => e.toString()).join(' | ');
