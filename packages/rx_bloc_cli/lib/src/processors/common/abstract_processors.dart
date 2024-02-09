import '../../models/generator_arguments.dart';

/// Contract defining a single processor unit responsible for handling
/// a single action.
abstract class AbstractProcessor<T> {
  /// Default processor constructor accepting generator arguments
  AbstractProcessor(this.args);

  /// Generator arguments containing flags for project generation
  final GeneratorArguments args;

  /// Method performing the actual processing
  T execute();
}

/// Processor handling an action and returning no result
abstract class VoidProcessor extends AbstractProcessor<void> {
  /// Void processor default constructor
  VoidProcessor(super.args);
}

/// Processor used for handling and returning a string value
abstract class StringProcessor extends AbstractProcessor<String> {
  /// String processor default constructor
  StringProcessor(super.args);

  /// Optional string input
  late final String? input;
}
