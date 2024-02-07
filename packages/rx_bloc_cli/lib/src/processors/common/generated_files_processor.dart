import 'package:rx_bloc_cli/src/processors/android/app_build_gradle_processor.dart';
import 'package:rx_bloc_cli/src/processors/common/file_string_processor.dart';

import 'package:rx_bloc_cli/src/processors/ios/flutter_xcconfig_file_processor.dart';

import '../../models/generator_arguments.dart';
import '../android/android_build_gradle_processor.dart';
import '../android/android_manifest_processor.dart';
import '../ios/ios_runner_project_processor.dart';
import 'abstract_processors.dart';

/// Class managing and processing several generated files
class GeneratedFilesProcessor {
  /// Default constructor of the GeneratedFilesProcessor class
  GeneratedFilesProcessor(this.args);

  /// Project generation arguments
  final GeneratorArguments args;

  /// Output directory of generated project
  String get _outputDirectory => args.outputDirectory.path;

  /// List of (path,processor) tuples for processing generated files
  List<(String, StringProcessor)> get _processors => [
        ('android/app/build.gradle', AppBuildGradleProcessor(args)),
        ('android/build.gradle', AndroidBuildGradleProcessor(args)),
        (
          'android/app/src/main/AndroidManifest.xml',
          AndroidManifestProcessor(args),
        ),
        (
          'ios/Runner.xcodeproj/project.pbxproj',
          IOSRunnerProjectProcessor(args),
        ),
        ..._buildIOSFlutterXCConfigFileProcessorTargets(),
      ];

  /// Method processing generated files at given output directory
  Future<void> execute() async {
    for (var processorTuple in _processors) {
      FileStringProcessor(
        path: '$_outputDirectory/${processorTuple.$1}',
        processor: processorTuple.$2,
      )..execute();
    }
  }

  /// region Private methods

  /// Builds a list of target files to process. The files are xcconfig files
  /// located within the ios/Flutter directory
  List<(String, StringProcessor)>
      _buildIOSFlutterXCConfigFileProcessorTargets() => [
            'devDebug',
            'devProfile',
            'devRelease',
            'prodDebug',
            'prodProfile',
            'prodRelease',
            'sitDebug',
            'sitProfile',
            'sitRelease',
            'uatDebug',
            'uatProfile',
            'uatRelease',
          ]
              .map(
                (file) => (
                  'ios/Flutter/$file.xcconfig',
                  FlutterXCConfigFileProcessor(args, file),
                ),
              )
              .toList();

  /// endregion
}
