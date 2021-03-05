part of rx_bloc_generator;

/// Validates the main bloc file and provides the generator the needed data
class _BuildController {
  _BuildController({
    required this.rxBlocClass,
    required this.eventClass,
    required this.stateClass,
  });

  final ClassElement rxBlocClass;
  final ClassElement? eventClass;
  final ClassElement? stateClass;

  String generate() {
    // Check for any broken rules
    _validate();

    final String blocTypeClassName = '${rxBlocClass.displayName}Type';
    final String blocClassName = '\$${rxBlocClass.displayName}';
    final String eventClassName = eventClass!.displayName;
    final String stateClassName = stateClass!.displayName;
    final String blocFilePath = rxBlocClass.location?.components.first ?? '';
    final String mainBlocFileName =
        Uri.tryParse(blocFilePath, (blocFilePath.lastIndexOf('/') + 1))
                ?.toString() ??
            '';

    /// The output buffer containing all the generated code
    final StringBuffer _output = StringBuffer();

    <String>[
      /// .. part of '[rx_bloc_name]_bloc.dart'
      // TODO(Diev): Use [Directive.partOf] instead once `part of` is supported
      "part of '$mainBlocFileName';",

      // abstract class [RxBlocName]BlocType
      _BlocTypeClass(
        blocTypeClassName,
        eventClassName,
        stateClassName,
      ).build().toNullSafeDartCodeString(),

      // abstract class $[RxBlocName]Bloc
      _BlocClass(
        blocClassName,
        blocTypeClassName,
        eventClassName,
        stateClassName,
        eventClass!.methods,
        stateClass!.fields
            // Skip @RxBlocIgnoreState() ignored states
            .where((FieldElement field) =>
                field.getter is PropertyAccessorElement &&
                field.getter != null &&
                (field.getter!.metadata.isEmpty ||
                    !const TypeChecker.fromRuntime(RxBlocIgnoreState)
                        .hasAnnotationOf(field.getter)))
            .toList(),
      ).build().toNullSafeDartCodeString(),

      // class _[EventMethodName]EventArgs
      // ..._eventMethodsArgsClasses(),
      ...eventClass!.methods
          .where((MethodElement method) => method.isUsingArgumentClass)
          .map((MethodElement method) {
        return _EventArgumentsClass(method).build().toNullSafeDartCodeString();
      }).toList()
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
    if (eventClass == null) {
      throw _RxBlocGeneratorException(
        _generateMissingClassError(
          eventClass?.displayName ?? '',
          rxBlocClass.name,
        ),
      );
    }

    // Methods only - No fields should exist
    eventClass!.fields.forEach((field) {
      throw _RxBlocGeneratorException(
          '${eventClass!.name} should contain methods only,'
          ' while ${field.name} seems to be a field.');
    });
  }

  void _validateStates() {
    // States class required
    if (stateClass == null) {
      throw _RxBlocGeneratorException(
        _generateMissingClassError(
          eventClass?.displayName ?? '',
          rxBlocClass.name,
        ),
      );
    }

    // Fields only - No methods should exist
    stateClass!.methods.forEach((method) {
      throw _RxBlocGeneratorException(
          'State ${method.name}should be defined using the get keyword.');
    });

    stateClass!.accessors.forEach((fieldElement) {
      if (!fieldElement.isAbstract) {
        final name = fieldElement.name.replaceAll('=', '');
        throw _RxBlocGeneratorException(
            'State $name should not contain a body definition.');
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
              '$blocName$className class missing.',
              'Please make sure you have properly named and specified',
              'your class in the same file where the $blocName resides.'
            ], '\n\t'))
          .toString();
}

/// It is the main [DartFormatter]
extension _SpecNullSaferyExtensions on Spec {
  String toNullSafeDartCodeString() => DartFormatter().format(
        accept(
          DartEmitter(Allocator.none, false, true),
        ).toString(),
      );
}
