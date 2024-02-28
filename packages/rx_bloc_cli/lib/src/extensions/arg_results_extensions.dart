import 'dart:io';

import 'package:args/args.dart';
import 'package:rx_bloc_cli/src/models/ci_cd_type.dart';
import 'package:rx_bloc_cli/src/models/errors/command_usage_exception.dart';
import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';

import '../models/command_arguments/create_command_arguments.dart';

/// Provides an API to read values specific for RxBlocCLI from ArgResults
extension ArgumentsValueReader on ArgResults {
  /// Returns a boolean value indicating whether the command is run with
  /// `--interactive=true`
  bool get interactiveConfigurationEnabled =>
      readBool(CreateCommandArguments.interactive);

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
  String readString(CreateCommandArguments argument) {
    if (argument.type != CreateCommandArgumentType.string) {
      throw UnsupportedError('${argument.name} is not of type String');
    }
    return (this[argument.name] as String?) ?? argument.defaultValue();
  }

  /// Reads a boolean from the parsed values
  bool readBool(CreateCommandArguments argument) {
    if (argument.type != CreateCommandArgumentType.boolean) {
      throw UnsupportedError('${argument.name} is not of type bool');
    }
    return this[argument.name] as bool;
  }

  /// Reads a realtime communication type from the parsed values
  RealtimeCommunicationType readRealtimeCommunicationType(
      CreateCommandArguments argument) {
    if (argument.type != CreateCommandArgumentType.realTimeCommunicationEnum) {
      throw UnsupportedError(
          '${argument.name} is not of type RealtimeCommunicationType');
    }
    final value = this[argument.name] as String?;

    return (value != null)
        ? RealtimeCommunicationType.parse(value)
        : argument.defaultValue();
  }

  /// Reads a CI/CD type from the parsed values
  CICDType readCICDEnum(CreateCommandArguments argument) {
    if (argument.type != CreateCommandArgumentType.cicdTypeEnum) {
      throw UnsupportedError('${argument.name} is not of type CICDType');
    }
    final value = this[argument.name] as String?;

    return (value != null) ? CICDType.parse(value) : argument.defaultValue();
  }
}
