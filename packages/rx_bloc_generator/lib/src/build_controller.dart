part of '../rx_bloc_generator.dart';

/// Validates the main bloc file and provides the generator the needed data
class _BuildController {
  _BuildController({
    required this.rxBlocClass,
    required this.eventClass,
    required this.stateClass,
  });

  final ClassElement2 rxBlocClass;
  final ClassElement2? eventClass;
  final ClassElement2? stateClass;

  String generate() {
    // Check for any broken rules
    _validate();

    final blocTypeClassName = '${rxBlocClass.displayName}Type';
    final blocClassGenericTypes =
        rxBlocClass.typeParameters2.map((final t) => t.displayName);
    final blocClassGenericTypesString = blocClassGenericTypes.isNotEmpty
        ? '<${blocClassGenericTypes.join(', ')}>'
        : '';
    final blocClassName =
        '\$${rxBlocClass.displayName}$blocClassGenericTypesString';
    final eventClassName = eventClass!.displayName;
    final stateClassName = stateClass!.displayName;
    final blocFilePath =
        rxBlocClass.firstFragment.libraryFragment.source.uri.path;
    final mainBlocFileName =
        Uri.tryParse(blocFilePath, (blocFilePath.lastIndexOf('/') + 1))
                ?.toString() ??
            '';

    /// The output buffer containing all the generated code
    final output = StringBuffer();

    <String>[
      /// .. part of '[rx_bloc_name]_bloc.dart'
      Directive.partOf(mainBlocFileName).toDartCodeString(),

      // abstract class [RxBlocName]BlocType
      _BlocTypeClass(
        blocTypeClassName,
        eventClassName,
        stateClassName,
      ).build().toDartCodeString(),

      // abstract class $[RxBlocName]Bloc
      _BlocClass(
        blocClassName,
        blocTypeClassName,
        eventClassName,
        stateClassName,
        eventClass!.methods2,
        stateClass!.fields2
            // Skip @RxBlocIgnoreState() ignored states
            .where((FieldElement2 field) =>
                field.getter2 is PropertyAccessorElement2 &&
                field.getter2 != null &&
                (field.getter2!.metadata2.annotations.isEmpty ||
                    !const TypeChecker.typeNamed(RxBlocIgnoreState)
                        .hasAnnotationOf(field.getter2!)))
            .toList(),
      ).build().toDartCodeString(),

      // typedef _[EventMethodName]EventArgs
      ...eventClass!.methods2
          .where((MethodElement2 method) => method.isUsingRecord)
          .map((MethodElement2 method) {
        return method.argsRecord.typeDef().toDartCodeString();
      })
    ].forEach(output.writeln);

    return output.toString();
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
          rxBlocClass.name3 ?? '',
        ),
      );
    }

    // Methods only - No fields should exist
    for (var field in eventClass!.fields2) {
      throw _RxBlocGeneratorException(
          '${eventClass!.name3} should contain methods only,'
          ' while ${field.name3} seems to be a field.');
    }
  }

  void _validateStates() {
    // States class required
    if (stateClass == null) {
      throw _RxBlocGeneratorException(
        _generateMissingClassError(
          eventClass?.displayName ?? '',
          rxBlocClass.name3 ?? '',
        ),
      );
    }

    // Fields only - No methods should exist
    for (var method in stateClass!.methods2) {
      throw _RxBlocGeneratorException(
          'State ${method.name3} should be defined using the get keyword.');
    }

    for (var fieldElement in stateClass!.fields2) {
      if (!(fieldElement.getter2?.isAbstract ?? false)) {
        final name = fieldElement.name3?.replaceAll('=', '');
        throw _RxBlocGeneratorException(
            'State $name should not contain a body definition.');
      }
    }
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
