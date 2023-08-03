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
