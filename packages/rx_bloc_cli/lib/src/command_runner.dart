import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

import 'commands/create_command.dart';
import 'commands/create_distribution_command.dart';
import 'rx_bloc_cli_constants.dart';
import 'rx_bloc_command_exception.dart';

/// Command runner that executes RxBloc specific actions
class RxBlocCommandRunner extends CommandRunner<int> {
  /// RxBloc Command Runner containing all currently supported commands
  RxBlocCommandRunner({
    Logger? logger,
  })  : _logger = logger ?? Logger(),
        super('rx_bloc_cli', 'Rx Bloc Command Line Interface') {
    argParser.addFlag(
      'version',
      abbr: 'v',
      negatable: false,
      help: 'Print the current version.',
    );
    addCommand(CreateCommand(logger: _logger));
    addCommand(CreateDistributionCommand(logger: _logger));
  }

  final Logger _logger;
  late ArgResults _argResults;

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      _argResults = parse(args);
      return await runCommand(_argResults) ?? ExitCode.success.code;
    } on FormatException catch (e) {
      _logger
        ..err(e.message)
        ..info('')
        ..info(usage);
      return ExitCode.usage.code;
    } on UsageException catch (e) {
      _logger
        ..err(e.message)
        ..info('')
        ..info(usage);
      return ExitCode.usage.code;
    } on RxBlocCommandException catch (e) {
      _logger.err(e.message);
      return ExitCode.usage.code;
    }
  }

  @override
  Future<int?> runCommand(ArgResults topLevelResults) async {
    int? retCode = ExitCode.unavailable.code;

    if (topLevelResults['version'] == true) {
      _logger.info('package version: $rxBlocCliPackageVersion');
      retCode = ExitCode.success.code;
    } else {
      retCode = await super.runCommand(topLevelResults);
    }

    return retCode;
  }
}
