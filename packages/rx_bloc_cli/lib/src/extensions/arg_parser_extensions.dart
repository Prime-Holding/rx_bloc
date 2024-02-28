import 'package:args/args.dart';

import '../models/command_arguments/create_command_arguments.dart';

/// Utility methods for CommandArguments handling
extension ArgumentHandler on ArgParser {
  /// Adds a list of CommandArguments as ArgParser options
  void addCommandArguments(List<CreateCommandArguments> arguments) {
    for (final argument in arguments) {
      switch (argument.type) {
        case CreateCommandArgumentType.string:
        case CreateCommandArgumentType.realTimeCommunicationEnum:
          addOption(
            argument.name,
            help: argument.help,
            allowed: argument.type.allowed,
            mandatory: argument.mandatory,
          );
        case CreateCommandArgumentType.boolean:
          addFlag(
            argument.name,
            help: argument.help,
            defaultsTo: argument.defaultValue(),
            negatable: true,
          );
        case CreateCommandArgumentType.cicdTypeEnum:
          addOption(
            argument.name,
            help: argument.help,
            allowed: argument.type.allowed,
          );
      }
    }
  }
}
