import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rx_bloc_cli/src/models/configurations/auth_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/feature_configuration.dart';
import 'package:rx_bloc_cli/src/models/errors/command_usage_exception.dart';
import 'package:rx_bloc_cli/src/models/generator_arguments.dart';
import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';

import 'command_arguments.dart';
import 'configurations/project_configuration.dart';
import 'readers/command_arguments_reader.dart';

part 'providers/project_configuration_provider.dart';

part 'providers/auth_configuration_provider.dart';

part 'providers/feature_configuration_provider.dart';

/// The class responsible for transforming command arguments
/// to arguments that contain all the necessary data for project generation.
class GeneratorArgumentsProvider {
  /// Constructor with output directory, reader an logger parameters
  GeneratorArgumentsProvider(
    this._outputDirectory,
    CommandArgumentsReader reader,
    Logger logger,
  )   : _projectConfigurationProvider = _ProjectConfigurationProvider(
          reader,
        ),
        _authConfigurationProvider = _AuthConfigurationProvider(
          reader,
          logger,
        ),
        _featureConfigurationProvider = _FeatureConfigurationProvider(
          reader,
        );

  final Directory _outputDirectory;

  final _ProjectConfigurationProvider _projectConfigurationProvider;
  final _AuthConfigurationProvider _authConfigurationProvider;
  final _FeatureConfigurationProvider _featureConfigurationProvider;

  /// Reads project generation arguments from provided reader source
  /// Performs necessary input validations
  GeneratorArguments readGeneratorArguments() {
    final projectConfiguration = _projectConfigurationProvider.read();
    final authConfiguration = _authConfigurationProvider.read();
    final featureConfiguration = _featureConfigurationProvider.read();

    return GeneratorArguments(
      outputDirectory: _outputDirectory,
      projectConfiguration: projectConfiguration,
      authConfiguration: authConfiguration,
      featureConfiguration: featureConfiguration,
    );
  }
}
