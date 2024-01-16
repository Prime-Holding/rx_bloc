import 'dart:io';

import 'package:mason/mason.dart';

import '../models/generator_arguments.dart';
import '../templates/rx_bloc_flavor_config_bundle.dart';

/// Utility class containing logic for flavor generation
class FlavorGenerator {
  /// Generates flavor config and uses it to add flavors to project
  static Future<void> addFlavors(
    Future<MasonGenerator> Function(MasonBundle) generator,
    GeneratorArguments args,
  ) async {
    await _generateFlavorConfig(generator, args);

    final addFlavorizr = await Process.run(
      'flutter',
      [
        'pub',
        'add',
        'flutter_flavorizr',
      ],
      workingDirectory: args.outputDirectory.path,
    );

    final dartGet = await Process.run(
      'dart',
      ['pub', 'get'],
      workingDirectory: args.outputDirectory.path,
    );

    final runFlavorizr = await Process.run(
      'flutter',
      [
        'pub',
        'run',
        'flutter_flavorizr',
      ],
      workingDirectory: args.outputDirectory.path,
    );
  }

  ///region Helper functions

  /// Generates config file used to define flavors
  static Future<void> _generateFlavorConfig(
    Future<MasonGenerator> Function(MasonBundle) generator,
    GeneratorArguments arguments,
  ) async {
    final _bundle = await generator(rxBlocFlavorConfigBundle);
    var generatedFiles = await _bundle.generate(
      DirectoryGeneratorTarget(arguments.outputDirectory),
      vars: {
        'project_name': arguments.projectName,
        'domain_name': arguments.organisationDomain,
        'organization_name': arguments.organisationName,
      },
    );
  }

  /// endregion
}
