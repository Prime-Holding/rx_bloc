import 'dart:io';

import 'package:rx_bloc_cli/src/processors/common/string_processor.dart';

/// Processor handling a string from given file and writes it back into a file
/// with provided path
class FileStringProcessor {
  /// Default constructor for FileStringProcessor
  FileStringProcessor({
    required this.path,
    required this.processor,
  }) : file = File(path);

  /// Path of the file where to write the resulting contents
  final String path;

  /// The actual file used to write the resulting contents
  final File file;

  /// String processor used for handling the contents
  final StringProcessor processor;

  /// Method used to process and write the contents back
  void execute() {
    final contents = file.readAsStringSync();
    final result = processor.execute(contents);
    file.writeAsStringSync(result);
  }
}
