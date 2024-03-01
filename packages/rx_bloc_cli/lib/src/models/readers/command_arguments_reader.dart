import 'package:rx_bloc_cli/src/models/ci_cd_type.dart';

import '../../extensions/object_extensions.dart';
import '../command_arguments/create_command_arguments.dart';
import '../realtime_communication_type.dart';

/// Defines the main interface for reading command arguments
abstract class CommandArgumentsReader {
  /// Reads a value and optionally performs validation for the value
  T read<T extends Object>(
    CreateCommandArguments argument, {
    T Function(T)? validation,
  });
}

/// Base implementation of read without specific data source
abstract class BaseCommandArgumentsReader implements CommandArgumentsReader {
  @override
  T read<T extends Object>(
    CreateCommandArguments argument, {
    T Function(T)? validation,
  }) {
    if (!isSupported(argument)) {
      throw UnsupportedError('${argument.name} option is not supported!');
    }

    // If no validation is provided just return the value
    final validate = validation ?? ((value) => value);

    switch (argument.type) {
      case CreateCommandArgumentType.string:
        return validate(readString(argument).cast());
      case CreateCommandArgumentType.boolean:
        return validate(readBool(argument).cast());
      case CreateCommandArgumentType.realTimeCommunicationEnum:
        return validate(readRealtimeCommunicationEnum(argument).cast());
      case CreateCommandArgumentType.cicdTypeEnum:
        return validate(readCICDEnum(argument).cast());
    }
  }

  /// Returns whether the provided argument can be read
  bool isSupported(CreateCommandArguments argument);

  /// Reads a String value
  String readString(CreateCommandArguments argument);

  /// Reads a bool value
  bool readBool(CreateCommandArguments argument);

  /// Reads a RealtimeCommunicationType value
  RealtimeCommunicationType readRealtimeCommunicationEnum(
      CreateCommandArguments argument);

  /// Reads a CICDEnum value
  CICDType readCICDEnum(CreateCommandArguments argument);
}
