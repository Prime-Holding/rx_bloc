part of rx_bloc_generator;

/// Used for @RxBlocIgnoreState() annotation checking
final _ignoreStateAnnotationChecker =
    const TypeChecker.fromRuntime(RxBlocIgnoreState);

/// StatesGenerator is a class responsible for generating all the user-defined
/// states of a bloc. It generates all the states
/// delegated by the `RxBlocBuilder`
/// and handles appropriately errors that arise.
///
/// It takes in a [_statesClass] ClassElement which represents the states class
/// from which it creates everything needed for the states to work.
class StatesGenerator {
  /// The default constructor.
  StatesGenerator(this._statesClass);

  /// The output buffer containing generated states code
  final StringBuffer _stringBuffer = StringBuffer();

  /// The class containing all the user-defined states
  final ClassElement _statesClass;

  /// Writes to output string buffer
  void _writeln([Object obj]) => _stringBuffer.writeln(obj);

  /// Generates all states based on the passed in states class
  String generate() {
    _writeln('\n  ///region States');
    _writeln('\n');
    _writeln(_generateStates());
    _writeln('\n  ///endregion States');
    return _stringBuffer.toString();
  }

  /// Generates states string from states class while checking for any errors.
  String _generateStates() {
    // Check if there are any states defined as methods
    _statesClass.methods.forEach((method) {
      logError(
          'State \'${method.name}\' should be defined using the get keyword.');
    });

    return _statesClass.accessors
        .checkForErroneousStates()
        .filterRxBlocIgnoreState()
        .map((element) => element.variable)
        .mapToStates()
        .join('\n');
  }
}

extension _FilteringAndCheckingStates on List<PropertyAccessorElement> {
  /// Performs a check and logs any non-abstract states
  List<PropertyAccessorElement> checkForErroneousStates() {
    forEach((fieldElement) {
      final name = fieldElement.name.replaceAll('=', '');
      if (!fieldElement.isAbstract)
        logError('State \'$name\' should not contain a body definition.');
    });
    return this;
  }

  /// Returns all properties that do not contain the
  /// @RxBlocIgnoreState() annotation
  Iterable<PropertyAccessorElement> filterRxBlocIgnoreState() =>
      where((fieldElement) {
        if (fieldElement.metadata.isEmpty) return true;
        return !_ignoreStateAnnotationChecker.hasAnnotationOf(fieldElement);
      });
}

extension _MapToStates on Iterable<PropertyInducingElement> {
  /// Maps all of properties to their states counterpart
  Iterable<String> mapToStates() => map((fieldElement) => '''
  ///region ${fieldElement.displayName}
  ${fieldElement.type} _${fieldElement.displayName}State;

  @override
  ${fieldElement.type} get ${fieldElement.displayName} => _${fieldElement.displayName}State ??= _mapTo${fieldElement.displayName.capitalize()}State();

  ${fieldElement.type} _mapTo${fieldElement.displayName.capitalize()}State();
  ///endregion ${fieldElement.displayName}
  ''');
}
