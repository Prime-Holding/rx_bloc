import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:rx_bloc_cli/src/templates/rx_bloc_base_bundle.dart';
import 'package:rx_bloc_cli/src/utils/git_ignore_creator.dart';

/// CreateCommand is a custom command that helps you create a new project.
class CreateCommand extends Command<int> {
  CreateCommand({
    Logger logger,
    MasonBundle bundle,
    Future<MasonGenerator> Function(MasonBundle) generator,
  })  : _logger = logger ?? Logger(),
        _bundle = bundle ?? rxBlocBaseBundle,
        _generator = generator ?? MasonGenerator.fromBundle {
    argParser.addOption(
      _orgNameString,
      help: 'The organisation name (eg.: com.example ).',
      defaultsTo: null,
    );
    argParser.addOption(
      _projectNameString,
      help: 'The project name for this new Flutter project. '
          'This must be a valid dart package name.',
      defaultsTo: null,
    );
    argParser.addOption(
      _analyticsString,
      help: 'Enables Google analytics for the project',
      defaultsTo: 'true',
    );
  }

  /// region Fields

  final _projectNameString = 'project-name';
  final _orgNameString = 'org';
  final _analyticsString = 'use-analytics';

  final Logger _logger;
  final MasonBundle _bundle;
  final Future<MasonGenerator> Function(MasonBundle) _generator;

  /// [ArgResults] which can be overridden for testing.
  ArgResults argResultOverrides;

  ArgResults get _argResults => argResultOverrides ?? argResults;

  /// Regex for package name
  final RegExp _packageNameRegExp = RegExp('[a-z_][a-z0-9_]*');

  /// Regex for organization name and domain
  final RegExp _orgNameDomainRegExp =
      RegExp('^([A-Za-z]{2,6})(\\.(?!-)[A-Za-z0-9-]{1,63}(?<!-))+\$');

  /// endregion

  /// region Command requirements

  @override
  String get name => 'create';

  @override
  String get description => 'Creates a new project in the specified directory.';

  @override
  Future<int> run() async {
    await _generateViaMasonBundle();
    return ExitCode.success.code;
  }

  /// endregion

  /// region Code generation

  void _generateViaMasonBundle() async {
    final outputDirectory = _outputDirectory;
    final projectName = _projectName;

    final orgSeparatorIndex = _organizationName.indexOf('.');
    final orgDomain = _organizationName.substring(0, orgSeparatorIndex);
    final orgName = _organizationName.substring(orgSeparatorIndex + 1);

    _logger.info('');
    final generateDone = _logger.progress('Bootstrapping');
    final generator = await _generator(_bundle);
    final fileCount = await generator.generate(
      DirectoryGeneratorTarget(outputDirectory, _logger),
      vars: {
        'project_name': projectName,
        'domain_name': orgDomain,
        'organization_name': orgName,
        'analytics': _enableAnalytics,
      },
    );
    GitIgnoreCreator.generate(_outputDirectory.path);

    generateDone('Bootstrapping done');
    _writeOutputLog(fileCount);
  }

  /// endregion

  /// region Properties

  /// Gets the project name. If no project name was specified, the current
  /// directory path name is used instead.
  String get _projectName {
    final projectName = _argResults[_projectNameString] ??
        path.basename(path.normalize(_outputDirectory.absolute.path));
    _validateProjectName(projectName);
    return projectName;
  }

  /// Returns the organization name with domain in front of it
  String get _organizationName {
    final orgName = _argResults[_orgNameString];
    _validateOrganisationName(orgName);
    return orgName;
  }

  /// Gets the directory used for the file generation
  Directory get _outputDirectory {
    final rest = _argResults.rest;
    _validateOutputDirectoryArg(rest);
    return Directory(rest.first);
  }

  /// Returns whether the project will use analytics or not
  bool get _enableAnalytics {
    final analyticsEnabled = _argResults[_analyticsString];
    return analyticsEnabled.toLowerCase() != 'false';
  }

  /// endregion

  /// region Validation

  void _validateProjectName(String name) {
    final isValidProjectName = _stringMatchesRegex(_packageNameRegExp, name);
    if (!isValidProjectName) {
      throw UsageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
        usage,
      );
    }
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

  void _validateOrganisationName(String orgName) {
    if (orgName == null || orgName.trim().isEmpty)
      throw UsageException('No organisation name specified.', usage);
    if (!_stringMatchesRegex(_orgNameDomainRegExp, orgName))
      throw UsageException('Invalid organisation name.', usage);
  }

  bool _stringMatchesRegex(RegExp regex, String name) {
    final match = regex.matchAsPrefix(name);
    return match != null && match.end == name.length;
  }

  /// endregion

  /// region Output logging

  /// Writes an output log with the status of the file generation
  void _writeOutputLog(int fileCount) async {
    final filesGeneratedStr = fileCount == 0
        ? 'No files generated.'
        : 'Generated $fileCount file(s):';

    _logger
      ..info('${lightGreen.wrap('✓')} $filesGeneratedStr')
      ..info('')
      ..delayed('');

    _successMessageLog(fileCount);

    _logger
      ..delayed('')
      ..flush(_logger.success);
  }

  /// Message shown in the output log upon successful generation
  _successMessageLog(int fileCount) {
    if (fileCount < 1) return;

    _delayedLog('Generated project with package name: '
        '${lightCyan.wrap('$_organizationName.$_projectName')}');

    _delayedLog('${_enableAnalytics ? 'Using' : 'Not using'} Google Analytics',
        success: _enableAnalytics);
  }

  /// Shows a delayed log with a success symbol in front of it
  _delayedLog(String text, {success: true, newline: false}) {
    final symbol = success ? lightGreen.wrap('✓') : red.wrap('x');
    _logger.delayed('$symbol ${white.wrap(text)}');
    if (newline) _logger.delayed('');
  }

  /// endregion

}
