import 'package:args/args.dart';
import 'package:rx_bloc_cli/src/models/ci_cd_type.dart';

import '../../extensions/arg_results_extensions.dart';
import '../command_arguments.dart';
import '../realtime_communication_type.dart';
import 'command_arguments_reader.dart';

/// Concrete implementation reading arguments non-interactively from ArgResults
final class NonInteractiveArgumentsReader extends BaseCommandArgumentsReader {
  /// Constructor for ArgResultsReader
  NonInteractiveArgumentsReader(this._argResults);

  final ArgResults _argResults;

  @override
  bool isSupported(CommandArguments argument) => true;

  @override
  String readString(CommandArguments argument) =>
      _argResults.readString(argument);

  @override
  bool readBool(CommandArguments argument) => _argResults.readBool(argument);

  @override
  RealtimeCommunicationType readRealtimeCommunicationEnum(
    CommandArguments argument,
  ) =>
      _argResults.readRealtimeCommunicationType(argument);

  @override
  CICDType readCICDEnum(CommandArguments argument) =>
      _argResults.readCICDEnum(argument);
}
