library rx_bloc_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:source_gen/source_gen.dart';

import 'src/rx_bloc_generator.dart';
import 'src/utilities/utilities.dart';

/// The entry point of the RxBloc code generation
Builder rxBlocGenerator(BuilderOptions options) {
  return LibraryBuilder(
    RxBlocGeneratorForAnnotation(),
    generatedExtension: '.rxb.g.dart',
  );
}

/// The generator.
class RxBlocGeneratorForAnnotation extends GeneratorForAnnotation<RxBloc> {
  /// Generate string that represents error when a missing class is detected.
  ///
  /// The function takes a [className] which represents the missing class that
  /// is tied closely to the [blocName] bloc. The [className] represents either
  /// the user-defined or the default value for the events/states class that
  /// is vital for proper bloc generation.
  String _generateMissingClassError(String className, String blocName) {
    final buffer = StringBuffer()
      ..write('\'$blocName$className\' class missing.\n')
      ..write('\n\tPlease make sure you have properly named and specified')
      ..write('\n\tyour class in the same file where the $blocName resides.');

    // ignore: cascade_invocations
    return buffer.toString();
  }

  /// Generates the bloc based on the class with the @RxBloc() annotation.
  /// If either the states or events class is missing the file is not generated.
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    // return early if annotation is used for a none class element
    if (element is! ClassElement) return null;

    final classElement = element as ClassElement;

    final libraryReader = LibraryReader(classElement.library);

    final eventsClassName = annotation.read('eventsClassName')?.stringValue;
    final statesClassName = annotation.read('statesClassName')?.stringValue;

    final eventsClass = libraryReader.classes.firstWhere(
        (classElement) => classElement.displayName.contains(eventsClassName),
        orElse: () => null);

    final statesClass = libraryReader.classes.firstWhere(
        (classElement) => classElement.displayName.contains(statesClassName),
        orElse: () => null);

    // Use the events/states class name in combination with the bloc name to
    // display appropriate error message when class is missing
    if (eventsClass == null)
      logError(_generateMissingClassError(eventsClassName, classElement.name));
    if (statesClass == null)
      logError(_generateMissingClassError(statesClassName, classElement.name));

    // if either one of the classes are missing, don't generate the bloc
    if (statesClass != null && eventsClass != null)
      return RxBlocGenerator(classElement, eventsClass, statesClass).generate();
  }
}
