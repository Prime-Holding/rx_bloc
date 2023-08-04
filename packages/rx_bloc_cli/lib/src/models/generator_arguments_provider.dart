import 'dart:io';

import 'package:mason/mason.dart';
import 'package:rx_bloc_cli/src/models/errors/command_usage_exception.dart';
import 'package:rx_bloc_cli/src/models/generator_arguments.dart';
import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';

import 'command_arguments.dart';
import 'readers/command_arguments_reader.dart';

part 'providers/project_metadata_provider.dart';

part 'providers/auth_configuration_provider.dart';

part 'providers/communication_configuration_provider.dart';

part 'providers/dev_configuration_provider.dart';

part 'providers/feature_configuration_provider.dart';

/// The class responsible for transforming command arguments
/// to arguments that contain all the necessary data for project generation.
class GeneratorArgumentsProvider {
  /// Constructor with output directory, reader an logger parameters
  GeneratorArgumentsProvider(
    this._outputDirectory,
    this._reader,
    this._logger,
  )   : _projectMetadataProvider = _ProjectMetadataProvider(
          _reader,
          _logger,
        ),
        _authConfigurationProvider = _AuthConfigurationProvider(
          _reader,
          _logger,
        ),
        _communicationConfigurationProvider =
            _CommunicationConfigurationProvider(
          _reader,
          _logger,
        ),
        _devConfigurationProvider = _DevConfigurationProvider(
          _reader,
          _logger,
        ),
        _featureConfigurationProvider = _FeatureConfigurationProvider(
          _reader,
          _logger,
        );

  final Directory _outputDirectory;
  final CommandArgumentsReader _reader;
  final Logger _logger;

  final _ProjectMetadataProvider _projectMetadataProvider;
  final _AuthConfigurationProvider _authConfigurationProvider;
  final _CommunicationConfigurationProvider _communicationConfigurationProvider;
  final _DevConfigurationProvider _devConfigurationProvider;
  final _FeatureConfigurationProvider _featureConfigurationProvider;

  /// Reads project generation arguments from provided reader source
  /// Performs necessary input validations
  GeneratorArguments readGeneratorArguments() {
    final project = _projectMetadataProvider.read();
    final authentication = _authConfigurationProvider.read();
    final communication = _communicationConfigurationProvider.read();
    final dev = _devConfigurationProvider.read();
    final features = _featureConfigurationProvider.read();

    return GeneratorArguments(
      outputDirectory: _outputDirectory,
      projectName: project.projectName,
      organisation: project.organisation,
      organisationName: project.organisationName,
      organisationDomain: project.organisationDomain,
      loginEnabled: authentication.loginEnabled,
      socialLoginsEnabled: authentication.socialLoginsEnabled,
      otpEnabled: authentication.otpEnabled,
      hasAuthentication: authentication.authenticationEnabled,
      analyticsEnabled: communication.analyticsEnabled,
      deeplinksEnabled: communication.deepLinkEnabled,
      pushNotificationsEnabled: communication.pushNotificationsEnabled,
      realtimeCommunicationEnabled: communication.realtimeCommunicationEnabled,
      usesFirebase: communication.usesFirebase,
      devMenuEnabled: dev.devMenuEnabled,
      patrolTestsEnabled: dev.patrolTestsEnabled,
      changeLanguageEnabled: features.changeLanguageEnabled,
      counterEnabled: features.counterEnabled,
      widgetToolkitEnabled: features.widgetToolkitEnabled,
    );
  }
}
