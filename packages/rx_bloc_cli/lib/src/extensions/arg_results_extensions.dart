import 'dart:io';

import 'package:args/args.dart';
import 'package:rx_bloc_cli/src/models/errors/command_usage_exception.dart';

import '../models/command_arguments.dart';

/// Provides an API to read values specific for RxBlocCLI from ArgResults
extension ArgumentsValueReader on ArgResults {
  /// Returns a boolean value indicating whether the command is run with
  /// `--interactive=true`
  bool get interactiveConfigurationEnabled =>
      readBool(CommandArguments.interactive.name) ??
      CommandArguments.interactive.defaultValue();

  /// Returns the provided output directory from the remaining arguments (rest)
  /// Throws if no output directory or multiple output directories are specified
  Directory get outputDirectory {
    final remainingArguments = rest;

    if (remainingArguments.isEmpty) {
      throw CommandUsageException(
          'No option specified for the output directory.');
    }
    if (remainingArguments.length > 1) {
      throw CommandUsageException('Multiple output directories specified.');
    }

    return Directory(remainingArguments.first);
  }

  /// Reads a string from the parsed values
  String? readString(String name) =>
      this[name] is String ? this[name] as String : null;

  /// Reads a boolean from the parsed values
  bool? readBool(String name) {
    final option = readString(name);
    return (option != null) ? option.toLowerCase() == true.toString() : null;
  }
}
