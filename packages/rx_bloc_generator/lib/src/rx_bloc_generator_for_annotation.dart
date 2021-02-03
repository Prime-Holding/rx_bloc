part of rx_bloc_generator;

/// The generator.
class RxBlocGeneratorForAnnotation extends GeneratorForAnnotation<RxBloc> {
  /// Allows creating via `const` as well as enforces immutability here.
  const RxBlocGeneratorForAnnotation();

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
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    // return early if annotation is used for a none class element
    if (element is! ClassElement) return null;

    final ClassElement classElement = element as ClassElement;

    final LibraryReader libraryReader = LibraryReader(classElement.library);

    final String eventsClassName = // eventsClassName: "Events"
        annotation.read('eventsClassName')?.stringValue;

    final String statesClassName = // statesClassName: "States"
        annotation.read('statesClassName')?.stringValue;

    /// abstract class NewsBlocEvents {
    //   void fetch();
    // }
    final ClassElement eventsClass = libraryReader.classes.firstWhere(
        (classElement) => classElement.displayName.contains(eventsClassName),
        orElse: () => null);

    /// abstract class NewsBlocStates {
    //   Stream<List<News>> get news;
    // }
    final ClassElement statesClass = libraryReader.classes.firstWhere(
        (classElement) => classElement.displayName.contains(statesClassName),
        orElse: () => null);

    // Use the events/states class name in combination with the bloc name to
    // display appropriate error message when class is missing
    if (eventsClass == null) {
      logError(_generateMissingClassError(eventsClassName, classElement.name));
    }
    if (statesClass == null) {
      logError(_generateMissingClassError(statesClassName, classElement.name));
    }

    // if either one of the classes are missing, don't generate the bloc
    if (statesClass != null && eventsClass != null) {
      return RxBlocGenerator(classElement, eventsClass, statesClass).generate();
    }

    return null;
  }
}
