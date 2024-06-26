
import 'package:rx_bloc_cli/src/processors/common/file_string_processor.dart';
import 'package:rx_bloc_cli/src/processors/common/shell_script_processor.dart';

import 'package:rx_bloc_cli/src/processors/ios/podfile_processor.dart';

import '../../models/generator_arguments.dart';
import '../cicd/ci_cd_config_file_processor.dart';
import '../ide/idea_workspace_processor.dart';
import '../ios/xcode_file_registrant.dart';
import 'abstract_processors.dart';

/// Class managing and processing several generated files after the generation
/// process is done
class GeneratedFilesPostProcessor {
  /// Default constructor of the GeneratedFilesPostProcessor class
  GeneratedFilesPostProcessor(this.args);

  /// Project generation arguments
  final GeneratorArguments args;

  /// Output directory of generated project
  String get _outputDirectory => args.outputDirectory.path;

  /// Currently generated shell scripts
  static const _shellScripts = [
    'bin/build_runner_build.sh',
    'bin/build_runner_watch.sh',
    'bin/generate_goldens.sh',
    'bin/run_e2e_test_dev.sh',
    'bin/run_e2e_test_sit.sh',
    'bin/run_e2e_test_uat.sh',
    'bin/run_e2e_test_prod.sh',
    'bin/start_server.sh',
  ];

  /// List of (path,processor) tuples for processing generated files
  List<(String, StringProcessor)> get _fileStringProcessors => [
        ('ios/Podfile', PodfileProcessor(args)),
        ('.idea/workspace.xml', IdeaWorkspaceProcessor(args)),
        (
          '.github/workflows/build_and_deploy_app.yaml',
          CICDConfigFileProcessor(args)
        ),
        (
          '.github/workflows/fastlane_android_custom_build_and_deploy.yaml',
          CICDConfigFileProcessor(args)
        ),
        (
          '.github/workflows/fastlane_ios_custom_build_and_deploy.yaml',
          CICDConfigFileProcessor(args)
        ),
        (
        'codemagic.yaml',
        CICDConfigFileProcessor(args)
        ),
      ];

  List<VoidProcessor> get _voidProcessors => [
        XCodeFileRegistrant(args),
        ShellScriptProcessor(args, scripts: _shellScripts),
      ];

  /// Method processing generated files at given output directory
  Future<void> execute() async {
    // Execute all listed file processors
    for (var processorTuple in _fileStringProcessors) {
      FileStringProcessor(
        path: '$_outputDirectory/${processorTuple.$1}',
        processor: processorTuple.$2,
      )..execute();
    }

    // Execute all processors without return type
    for (var processor in _voidProcessors) {
      processor.execute();
    }
  }
}
