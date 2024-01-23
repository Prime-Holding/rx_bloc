import 'dart:io';

import 'package:rx_bloc_cli/src/processors/android/app_build_gradle_processor.dart';
import 'package:rx_bloc_cli/src/processors/common/file_string_processor.dart';
import 'package:rx_bloc_cli/src/processors/common/string_processor.dart';

import '../../models/generator_arguments.dart';

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
        ('android/app/build.gradle', AppBuildGradleProcessor()),
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
}
