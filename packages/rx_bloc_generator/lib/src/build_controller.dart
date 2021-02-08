part of rx_bloc_generator;

/// Validates the main bloc file and provides the generator the needed data
class _BuildController {
  _BuildController({this.mainBloc, this.annotation, this.libraryReader})
      : _eventsClassName = annotation.read('eventsClassName')?.stringValue,
        _statesClassName = annotation.read('statesClassName')?.stringValue;

  final ClassElement mainBloc;
  final ConstantReader annotation;
  final LibraryReader libraryReader;

  String _fileContent;

  /// Provides a string class name. Example: 'Events'
  final String _eventsClassName;

  /// Provides a string class name. Example: 'States'
  final String _statesClassName;

  ClassElement _eventsElementSingleton;

  /// Provides the events class as [ClassElement]
  ///
  /// abstract class [RxBlocName]BlocEvents {
  //   void fetch();
  // }
  ClassElement get _eventsClass =>
      _eventsElementSingleton ??= libraryReader.classes.firstWhere(
          (classElement) => classElement.displayName.contains(_eventsClassName),
          orElse: () => null);

  ClassElement _statesElementSingleton;

  /// Provides the states class as [ClassElement]
  ///
  /// abstract class [RxBlocName]BlocEvents {
  //   void fetch();
  // }
  ClassElement get _statesClass =>
      _statesElementSingleton ??= libraryReader.classes.firstWhere(
          (classElement) => classElement.displayName.contains(_statesClassName),
          orElse: () => null);

  String get _blocFilePath => mainBloc.location.components.first;

  String get _mainBlocFileName =>
      Uri.tryParse(_blocFilePath, (_blocFilePath.lastIndexOf('/') + 1))
          ?.toString() ??
      '';

  void generate() {
    // Check for any broken rules
    _validate();

    _fileContent = _RxBlocCodeBuilder(
      mainBloc.displayName,
      _eventsClass.displayName,
      _eventsClass.methods,
      _statesClass.displayName,
      _statesClass.fields,
      _mainBlocFileName,
    ).build();
  }

  /// Checks and logs if there is anything missed
  void _validate() {
    _validateEvents();
    _validateStates();
  }

  void _validateEvents() {
    // Events class required
    if (_eventsClass == null) {
      throw _RxBlocGeneratorException(
          _generateMissingClassError(_eventsClassName, mainBloc.name));
    }

    // Methods only - No fields should exist
    _eventsClass.fields.forEach((field) {
      throw _RxBlocGeneratorException(
          '${_eventsClass.name} should contain methods only,'
          ' while ${field.name} seems to be a field.');
    });
  }

  void _validateStates() {
    // States class required
    if (_statesClass == null) {
      throw _RxBlocGeneratorException(
          _generateMissingClassError(_eventsClassName, mainBloc.name));
    }

    // Fields only - No methods should exist
    _statesClass.methods.forEach((method) {
      throw _RxBlocGeneratorException(
          'State ${method.name}should be defined using the get keyword.');
    });

    _statesClass.accessors.forEach((fieldElement) {
      if (!fieldElement.isAbstract) {
        final name = fieldElement.name.replaceAll('=', '');
        throw _RxBlocGeneratorException(
            'State ${name} should not contain a body definition.');
      }
    });
  }

  /// Generate string that represents error when a missing class is detected.
  ///
  /// The function takes a [className] which represents the missing class that
  /// is tied closely to the [blocName] bloc. The [className] represents either
  /// the user-defined or the default value for the events/states class that
  /// is vital for proper bloc generation.
  String _generateMissingClassError(String className, String blocName) =>
      (StringBuffer()
            ..writeAll(<String>[
              '${blocName}${className} class missing.',
              'Please make sure you have properly named and specified',
              'your class in the same file where the ${blocName} resides.'
            ], '\n\t'))
          .toString();

  String getFileContent() => _fileContent;
}
