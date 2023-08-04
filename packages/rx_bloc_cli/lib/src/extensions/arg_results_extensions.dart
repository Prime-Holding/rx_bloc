import 'dart:io';

import 'package:args/args.dart';
import 'package:rx_bloc_cli/src/extensions/object_extensions.dart';

import '../models/command_arguments.dart';

/// Provides an API to read values specific for RxBlocCLI from ArgResults
extension ArgumentsValueReader on ArgResults {
  /// Returns a boolean value indicating whether the command is run with
  /// ```--interactive=true```
  bool get interactiveConfigurationEnabled {
    assert(CommandArguments.interactive.type == ArgumentType.boolean);
    return readBool(
      CommandArguments.interactive.name,
      defaultValue: CommandArguments.interactive.defaultValue.cast(),
    );
  }

  /// Returns the provided output directory from the remaining arguments (rest)
  /// Throws if no output directory or multiple output directories are specified
  Directory get outputDirectory {
    final remainingArguments = rest;

    if (remainingArguments.isEmpty) {
      throw Exception('No option specified for the output directory.');
    }
    if (remainingArguments.length > 1) {
      throw Exception('Multiple output directories specified.');
    }

    return Directory(remainingArguments.first);
  }

  /// Reads a string from the parsed values or provides default value
  String readString(String name, {required String defaultValue}) =>
      this[name] is String ? this[name] as String : defaultValue;

  /// Reads a boolean from the parsed values or provides default value
  bool readBool(String name, {required bool defaultValue}) {
    final option = readString(name, defaultValue: defaultValue.toString());
    return option.toLowerCase() == true.toString();
  }
}
