part of rx_bloc_generator;

/// Validates the main bloc file and provides the generator the needed data
class _BuildController {
  _BuildController({
    this.rxBlocClass,
    this.annotation,
    this.libraryReader,
  })  : _eventsClassKey = annotation.read('eventsClassName')?.stringValue,
        _statesClassKey = annotation.read('statesClassName')?.stringValue;

  final ClassElement rxBlocClass;
  final ConstantReader annotation;
  final LibraryReader libraryReader;

  /// Provides a string class name. Example: 'Events'
  final String _eventsClassKey;

  /// Provides a string class name. Example: 'States'
  final String _statesClassKey;

  ClassElement _eventsElementSingleton;

  /// Provides the events class as [ClassElement]
  ///
  /// abstract class [RxBlocName]BlocEvents {
  //   void fetch();
  // }
  ClassElement get _eventClass =>
      _eventsElementSingleton ??= libraryReader.classes.firstWhere(
          (classElement) => classElement.displayName.contains(_eventsClassKey),
          orElse: () => null);

  ClassElement _statesElementSingleton;

  /// Provides the states class as [ClassElement]
  ///
  /// abstract class [RxBlocName]BlocEvents {
  //   void fetch();
  // }
  ClassElement get _stateClass =>
      _statesElementSingleton ??= libraryReader.classes.firstWhere(
          (classElement) => classElement.displayName.contains(_statesClassKey),
          orElse: () => null);

  String get _blocFilePath => rxBlocClass.location.components.first;

  String get _mainBlocFileName =>
      Uri.tryParse(_blocFilePath, (_blocFilePath.lastIndexOf('/') + 1))
          ?.toString() ??
      '';

  String generate() {
    // Check for any broken rules
    _validate();

    String blocTypeClassName = '${rxBlocClass.displayName}Type';
    String blocClassName = '\$${rxBlocClass.displayName}';
    String eventClassName = _eventClass.displayName;
    String stateClassName = _stateClass.displayName;

    /// The output buffer containing all the generated code
    final StringBuffer _output = StringBuffer();

    <String>[
      /// .. part of '[rx_bloc_name]_bloc.dart'
      // TODO(Diev): Use [Directive.partOf] instead once `part of` is supported
      "part of '${_mainBlocFileName}';",

      // abstract class [RxBlocName]BlocType
      _BlocTypeClass(
        blocTypeClassName,
        eventClassName,
        stateClassName,
      ).build(),

      // abstract class $[RxBlocName]Bloc
      _BlocClass(
        blocClassName,
        blocTypeClassName,
        eventClassName,
        stateClassName,
        _eventClass.methods,
        _stateClass.fields
            // Skip @RxBlocIgnoreState() ignored states
            .where((FieldElement field) =>
                field.getter is PropertyAccessorElement &&
                (field.getter.metadata.isEmpty ||
                    !TypeChecker.fromRuntime(RxBlocIgnoreState)
                        .hasAnnotationOf(field.getter)))
            .toList(),
      ).build(),

      // class _[EventMethodName]EventArgs
      // ..._eventMethodsArgsClasses(),
      ..._eventClass.methods
          .where((MethodElement method) => method.parameters.length > 1)
          .map((MethodElement method) => _EventArgumentsClass(method).build())
          .toList(),
    ].forEach(_output.writeln);

    return _output.toString();
  }

  /// Checks and logs if there is anything missed
  void _validate() {
    _validateEvents();
    _validateStates();
  }

  void _validateEvents() {
    // Events class required
    if (_eventClass == null) {
      throw _RxBlocGeneratorException(
          _generateMissingClassError(_eventsClassKey, rxBlocClass.name));
    }

    // Methods only - No fields should exist
    _eventClass.fields.forEach((field) {
      throw _RxBlocGeneratorException(
          '${_eventClass.name} should contain methods only,'
          ' while ${field.name} seems to be a field.');
    });
  }

  void _validateStates() {
    // States class required
    if (_stateClass == null) {
      throw _RxBlocGeneratorException(
          _generateMissingClassError(_eventsClassKey, rxBlocClass.name));
    }

    // Fields only - No methods should exist
    _stateClass.methods.forEach((method) {
      throw _RxBlocGeneratorException(
          'State ${method.name}should be defined using the get keyword.');
    });

    _stateClass.accessors.forEach((fieldElement) {
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
}
