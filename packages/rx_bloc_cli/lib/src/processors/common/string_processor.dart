import '../../models/generator_arguments.dart';

/// Contract defining a string processor
abstract class StringProcessor {
  /// Default string processor constructor
  StringProcessor(this.args);

  /// Generator arguments containing flags for project generation
  final GeneratorArguments args;

  /// Method performing the actual string processing
  String execute(String? input);
}
