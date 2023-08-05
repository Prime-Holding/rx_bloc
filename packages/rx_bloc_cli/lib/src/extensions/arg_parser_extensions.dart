import 'package:args/args.dart';

import '../models/command_arguments.dart';

/// Utility methods for CommandArguments handling
extension ArgumentHandler on ArgParser {
  /// Adds a list of CommandArguments as ArgParser options
  void addCommandArguments(List<CommandArguments> arguments) {
    for (final argument in arguments) {
      addOption(
        argument.name,
        help: argument.help,
        allowed: argument.type.allowed,
        mandatory: argument.mandatory,
      );
    }
  }
}
