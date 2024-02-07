import 'dart:io';

import 'package:mason/mason.dart';

import '../models/generator_arguments.dart';
import '../templates/rx_bloc_flavor_config_bundle.dart';

/// Utility class containing logic for flavor generation
class FlavorGenerator {
  /// Flavor generation default constructor
  FlavorGenerator(this.generator);

  /// Generator function used to build the mason generator from its bundle
  final Future<MasonGenerator> Function(MasonBundle) generator;

  /// Generates flavor config and uses it to add flavors to project
  Future<void> addFlavors(GeneratorArguments args) async {
    await _generateFlavorConfig(generator, args);
    await _addFlavorizrToProject(args.outputDirectory.path);

    await Process.run(
      'flutter',
      ['pub', 'run', 'flutter_flavorizr'],
      workingDirectory: args.outputDirectory.path,
    );

    await Process.run(
      'ruby',
      [
        'setup_scripts/add_firebase_build_phase.rb',
        'ios/Runner.xcodeproj',
        'setup_scripts/firebase_build_script.sh',
      ],
      workingDirectory: args.outputDirectory.path,
    );
  }

  ///region Helper functions

  /// Generates config file used to define flavors
  Future<void> _generateFlavorConfig(
    Future<MasonGenerator> Function(MasonBundle) generator,
    GeneratorArguments arguments,
  ) async {
    final _bundle = await generator(rxBlocFlavorConfigBundle);
    await _bundle.generate(
      DirectoryGeneratorTarget(arguments.outputDirectory),
      vars: {
        'project_name': arguments.projectName,
        'domain_name': arguments.organisationDomain,
        'organization_name': arguments.organisationName,
      },
    );
  }

  /// Adds flavorizr to generated project so we can apply new flavors
  Future<void> _addFlavorizrToProject(String outputDir) async {
    await Process.run(
      'flutter',
      ['pub', 'add', 'flutter_flavorizr'],
      workingDirectory: outputDir,
    );

    await Process.run('flutter', ['pub', 'get'], workingDirectory: outputDir);
  }

  /// endregion
}
