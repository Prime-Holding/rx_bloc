import 'package:args/args.dart';
import 'package:rx_bloc_cli/src/extensions/object_extensions.dart';

import '../models/command_arguments.dart';

/// Utility methods for CommandArguments handling
extension ArgumentHandler on ArgParser {
  /// Adds a list of CommandArguments as ArgParser options
  void addCommandArguments(List<CommandArguments> arguments) {
    for (final argument in arguments) {
      switch (argument.type) {
        case ArgumentType.string:
        case ArgumentType.realTimeCommunicationEnum:
          addOption(
            argument.name,
            help: argument.help,
            allowed: argument.type.allowed,
            mandatory: argument.mandatory,
          );
        case ArgumentType.boolean:
          addFlag(
            argument.name,
            help: argument.help,
            defaultsTo: argument.defaultValue(),
            negatable: true,
          );
      }
    }
  }
}
