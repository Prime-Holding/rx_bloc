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

extension _ReadArgument on ArgResults {
  bool get isInteractiveConfigurationEnabled =>
      boolReadOrDefault(_CommandArgument.interactive);

  String stringOrDefault(_CommandArgument arg) {
    assert(arg.type == _ArgumentType.string, '');
    return _readOrDefault(arg);
  }

  bool boolReadOrDefault(_CommandArgument arg) {
    assert(arg.type == _ArgumentType.boolean, '');
    final enabled = _readOrDefault(arg).toLowerCase() == true.toString();
    return enabled;
  }

  _RealtimeCommunicationType get realTimeCommunicationType {
    final arg = _CommandArgument.realtimeCommunication;
    assert(arg.type == _ArgumentType.realTimeCommunicationEnum, '');
    return _RealtimeCommunicationType.values
        .firstWhere((element) => element.name == _readOrDefault(arg));
  }

  String _readOrDefault(_CommandArgument arg) =>
      _cast(this[arg.name]) ?? arg.defaultValue.toString();

  T? _cast<T>(dynamic value) => value is T ? value : null;
}
