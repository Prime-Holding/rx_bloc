part of rx_bloc_generator;

/// The generator.
class RxBlocGeneratorForAnnotation extends GeneratorForAnnotation<RxBloc> {
  /// Allows creating via `const` as well as enforces immutability here.
  const RxBlocGeneratorForAnnotation();

  /// Generates the bloc based on the class with the @RxBloc() annotation.
  /// If either the states or events class is missing the file is not generated.
  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    // TODO(Diev): This way it will log the errors one by one. Is it OK?
    try {
      // return early if annotation is used for a none class element
      // TODO(Diev): This doesn't seem good
      if (element is! ClassElement) return null;

      final ClassElement classElement = element as ClassElement;

      final LibraryReader libraryReader = LibraryReader(classElement.library);

      return (_FileController(
        mainBloc: classElement,
        annotation: annotation,
        libraryReader: libraryReader,
      )..generate())
          .getFileContent();
    } on _RxBlocGeneratorException catch (e) {
      // Log any exception and don't proceed
      logError(e.message);
      return null;
    } catch (e) {
      // TODO(Diev): Log it here too
      return null;
    }
  }
}
