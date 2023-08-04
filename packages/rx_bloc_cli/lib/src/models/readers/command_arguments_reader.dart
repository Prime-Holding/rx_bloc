import '../../extensions/object_extensions.dart';
import '../command_arguments.dart';
import '../realtime_communication_type.dart';

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
      throw UnsupportedError('${argument.name} can\'t be used interactively');
    }

    // If no validation is provided just return the value
    final validate = validation ?? ((value) => value);

    switch (argument.type) {
      case ArgumentType.string:
        return validate(readString(argument).cast());
      case ArgumentType.boolean:
        return validate(readBool(argument).cast());
      case ArgumentType.realTimeCommunicationEnum:
        return validate(readRealtimeCommunicationEnum(argument).cast());
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
