import 'dart:io';

import 'package:args/args.dart';
import 'package:rx_bloc_cli/src/extensions/string_extensions.dart';
import 'package:rx_bloc_cli/src/models/errors/command_usage_exception.dart';
import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';

import '../models/command_arguments.dart';

/// Provides an API to read values specific for RxBlocCLI from ArgResults
extension ArgumentsValueReader on ArgResults {
  /// Returns a boolean value indicating whether the command is run with
  /// `--interactive=true`
  bool get interactiveConfigurationEnabled =>
      readBool(CommandArguments.interactive);

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
  String readString(CommandArguments argument) =>
      (this[argument.name] as String?) ?? argument.defaultValue();

  /// Reads a boolean from the parsed values
  bool readBool(CommandArguments argument) =>
      (this[argument.name] as String?)?.toBool() ?? argument.defaultValue();

  /// Reads a realtime communication type from the parsed values
  RealtimeCommunicationType readRealtimeCommunicationType(
      CommandArguments argument) {
    final value = this[argument.name] as String?;

    return (value != null)
        ? RealtimeCommunicationType.parse(value)
        : argument.defaultValue();
  }
}
