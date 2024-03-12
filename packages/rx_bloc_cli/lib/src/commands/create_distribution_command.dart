import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rx_bloc_cli/src/extensions/arg_results_extensions.dart';
import 'package:rx_bloc_cli/src/templates/rx_bloc_distribution_repository_bundle.dart';

import '../utils/git_ignore_creator.dart';

/// CreateDistributionCommand is a custom command that helps you create
/// a new project for storing distribution files and credentials
class CreateDistributionCommand extends Command<int> {
  /// Default distribution creation constructor
  CreateDistributionCommand({
    Logger? logger,
    MasonBundle? bundle,
    Future<MasonGenerator> Function(MasonBundle)? generator,
    Map<String, dynamic>? vars,
  })  : _logger = logger ?? Logger(),
        _vars = vars,
        _bundle = bundle ?? rxBlocDistributionRepositoryBundle,
        _generator = generator ?? MasonGenerator.fromBundle;

  final Logger _logger;
  final MasonBundle _bundle;
  final Future<MasonGenerator> Function(MasonBundle) _generator;
  final Map<String, dynamic>? _vars;

  /// region Command requirements

  @override
  String get name => 'create_distribution';

  @override
  String get description =>
      'Creates a new distribution project in the specified directory.';

  @override
  Future<int> run() async {
    final args = argResults!;
    await _generateBundle(args.outputDirectory);
    await _postGeneration(args.outputDirectory);
    return ExitCode.success.code;
  }

  /// endregion

  /// region Private methods

  Future<void> _generateBundle(Directory outputDir) async {
    final generator = await _generator(_bundle);

    final fileGenerationProgress = _logger.progress('Bootstrapping');

    final filesCount = await generator.generate(
      DirectoryGeneratorTarget(outputDir),
      vars: _vars ?? {},
    );

    GitIgnoreCreator.generate(
      outputDir.path,
      gitignore: GitignoreType.distributionRepo,
    );

    fileGenerationProgress.complete('Bootstrapping done!');

    _writeOutputLogs(filesCount.length + 1);
  }

  void _writeOutputLogs(int numOfFiles) {
    _logger
      ..info('${lightGreen.wrap('✓')} Generated $numOfFiles files.')
      ..info('')
      ..delayed('');
  }

  Future<void> _postGeneration(Directory outputDirectory) async {
    final scripts = ['encode.sh', 'decode.sh'];

    for (var script in scripts) {
      await _updateShellScriptExecutePermission(
        '${outputDirectory.absolute.path}/$script',
      );
    }
  }

  Future<void> _updateShellScriptExecutePermission(String filePath) async {
    await Process.run(
      'chmod',
      [
        '+x',
        filePath,
      ],
    );
  }

  /// endregion
}
