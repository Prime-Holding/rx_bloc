import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rx_bloc_cli/src/templates/rx_bloc_distribution_repository_bundle.dart';

import '../models/bundle_generator.dart';

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
        _bundleGenerator =
            BundleGenerator(bundle ?? rxBlocDistributionRepositoryBundle),
        _generator = generator ?? MasonGenerator.fromBundle;

  final Logger _logger;
  final BundleGenerator _bundleGenerator;
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
    return ExitCode.success.code;
  }

  /// endregion
}
