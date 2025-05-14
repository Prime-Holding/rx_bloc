import 'package:rx_bloc_cli/src/processors/android/android_main_activity_processor.dart';
import 'package:rx_bloc_cli/src/processors/android/app_build_gradle_processor.dart';
import 'package:rx_bloc_cli/src/processors/android/gradle_wrapper_properties_processor.dart';
import 'package:rx_bloc_cli/src/processors/android/settings_gradle_processor.dart';
import 'package:rx_bloc_cli/src/processors/common/file_string_processor.dart';

import 'package:rx_bloc_cli/src/processors/ios/flutter_xcconfig_file_processor.dart';
import 'package:rx_bloc_cli/src/rx_bloc_cli_constants.dart';

import '../../models/generator_arguments.dart';
import '../../utils/flavor_generator.dart';
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
        ('android/app/build.gradle.kts', AppBuildGradleProcessor(args)),
        ('android/build.gradle', AndroidBuildGradleProcessor(args)),
        ('android/gradle/wrapper/gradle-wrapper.properties', GradleWrapperPropertiesProcessor(args)),
        ('android/settings.gradle.kts', SettingsGradle(args)),
        (
          'android/app/src/main/AndroidManifest.xml',
          AndroidManifestProcessor(args),
        ),
        (
          'android/app/src/main/kotlin/${args.organisationDomain}/${args.organisationName}/${args.projectName}/MainActivity.kt',
          AndroidMainActivityProcessor(args)
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
            ...FlavorGenerator.getFlavors(args)
                .map((flavor) => kIOSBuildModes.map((mode) => '$flavor$mode'))
                .fold(<String>[], (prev, cur) {
              prev.addAll(cur);
              return prev;
            }),
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
