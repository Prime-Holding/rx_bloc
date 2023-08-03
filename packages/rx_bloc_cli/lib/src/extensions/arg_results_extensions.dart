part of '../commands/create_command.dart';

extension _ArgResultsSpecificValues on ArgResults {
  bool get isInteractiveConfigurationEnabled => readBool(
        _CommandArgument.interactive.name,
        _CommandArgument.interactive.defaultValue.cast(),
      );

  Directory get outputDirectory {
    final args = rest;

    if (args.isEmpty) {
      throw Exception('No option specified for the output directory.');
    }
    if (args.length > 1) {
      throw Exception('Multiple output directories specified.');
    }
    return Directory(args.first);
  }

  String readString(String name, String defaultsTo) =>
      this[name] is String ? this[name] as String : defaultsTo;

  bool readBool(String name, bool defaultsTo) =>
      readString(name, defaultsTo.toString()).toLowerCase() == true.toString();
}
