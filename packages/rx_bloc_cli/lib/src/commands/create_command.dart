import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:rx_bloc_cli/src/templates/rx_bloc_base_bundle.dart';

final _projectNameString = 'project-name';

class CreateCommand extends Command<int> {
  CreateCommand({
    Logger logger,
    MasonBundle bundle,
    Future<MasonGenerator> Function(MasonBundle) generator,
  })  : _logger = logger ?? Logger(),
        _bundle = bundle ?? rxBlocBaseBundle,
        _generator = generator ?? MasonGenerator.fromBundle {
    argParser.addOption(
      _projectNameString,
      help: 'The project name for this new Flutter project. '
          'This must be a valid dart package name.',
      defaultsTo: null,
    );
  }

  final Logger _logger;
  final MasonBundle _bundle;
  final Future<MasonGenerator> Function(MasonBundle) _generator;

  /// [ArgResults] which can be overridden for testing.
  ArgResults argResultOverrides;

  ArgResults get _argResults => argResultOverrides ?? argResults;

  final RegExp _identifierRegExp = RegExp('[a-z_][a-z0-9_]*');

  @override
  String get name => 'create';

  @override
  String get description => 'Creates a new project in the specified directory.';

  @override
  Future<int> run() async {
    final outputDirectory = _outputDirectory;
    final projectName = _projectName;
    final generateDone = _logger.progress('Bootstrapping');
    final generator = await _generator(_bundle);
    final fileCount = await generator.generate(
      DirectoryGeneratorTarget(outputDirectory, _logger),
      vars: {'project_name': projectName},
    );

    generateDone('Bootstrapping complete');
    _writeOutputLog(fileCount);

    return ExitCode.success.code;
  }

  void _writeOutputLog(int fileCount) {
    _logger
      ..info(
        '${lightGreen.wrap('✓')} '
        'Generated $fileCount file(s):',
      )
      ..flush(_logger.success);
  }

  /// Gets the project name. If no project name was specified, uses the current
  /// directory path name instead.
  String get _projectName {
    final projectName = _argResults[_projectNameString] ??
        path.basename(path.normalize(_outputDirectory.absolute.path));
    _validateProjectName(projectName);
    return projectName;
  }

  void _validateProjectName(String name) {
    final isValidProjectName = _isValidPackageName(name);
    if (!isValidProjectName) {
      throw UsageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
        usage,
      );
    }
  }

  bool _isValidPackageName(String name) {
    final match = _identifierRegExp.matchAsPrefix(name);
    return match != null && match.end == name.length;
  }

  Directory get _outputDirectory {
    final rest = _argResults.rest;
    _validateOutputDirectoryArg(rest);
    return Directory(rest.first);
  }

  void _validateOutputDirectoryArg(List<String> args) {
    if (args.isEmpty) {
      throw UsageException(
        'No option specified for the output directory.',
        usage,
      );
    }

    if (args.length > 1) {
      throw UsageException('Multiple output directories specified.', usage);
    }
  }
}
