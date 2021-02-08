part of rx_bloc_generator;

/// String utilities
extension _StringExtensions on String {
  /// Capitalizes the first letter of the word
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';

  /// Converts string to red string when printed in terminal
  String toRedString() => '\x1B[31m${this}\x1B[0m';
}

extension _SpecExtensions on Spec {
  String toDartCodeString() => DartFormatter().format(
        accept(
          DartEmitter(),
        ).toString(),
      );
}

extension _FilteringAndCheckingStates on List<PropertyAccessorElement> {
  /// Returns all properties that do not contain the
  /// @RxBlocIgnoreState() annotation
  Iterable<PropertyAccessorElement> filterRxBlocIgnoreState() =>
      where((PropertyAccessorElement field) {
        if (field.metadata.isEmpty) return true;
        return !TypeChecker.fromRuntime(RxBlocIgnoreState)
            .hasAnnotationOf(field);
      });
}

extension _FieldElementExtensions on FieldElement {
  String get generatedFieldName => '_${name}State';

  String get generatedMethodName => '_mapTo${name.capitalize()}State';
}

extension _MethodElementExtensions on MethodElement {
  String get generatedFieldName => '_\$${name}Event';

  /// The name of the arguments class that will be generated if
  /// the event contains more than one parameter
  String get argumentsClassName => '_${name.capitalize()}EventArgs';

  ///Returns the stream type based on the number of the parameters of the method
  String get argumentsType {
    if (parameters.length > 1) {
      return argumentsClassName;
    }
    return parameters.isNotEmpty
        ? parameters.first.type.getDisplayString(withNullability: false)
        : 'void';
  }

  List<Parameter> buildOptionalParameters({bool toThis = false}) => parameters
      .where((ParameterElement parameter) => !parameter.isNotOptional)
      .map(
        (ParameterElement parameter) => Parameter(
          (b) => b
            ..toThis = toThis
            ..required = parameter.isRequiredNamed
            ..defaultTo = parameter?.defaultValueCode != null
                ? Code(parameter.defaultValueCode)
                : null
            ..named = parameter.isNamed
            ..name = parameter.name
            ..type = toThis
                ? null // We don't need the type in the constructor
                : refer(
                    parameter.type.getDisplayString(withNullability: false),
                  ),
        ),
      )
      .toList();

  List<Parameter> buildRequiredParameters({bool toThis = false}) => parameters
      .where((ParameterElement parameter) => parameter.isNotOptional)
      .map(
        (ParameterElement parameter) => Parameter(
          (b) => b
            ..toThis = toThis
            ..name = parameter.name
            ..type = toThis
                ? null // We don't need the type in the constructor
                : refer(
                    parameter.type.getDisplayString(withNullability: false),
                  ),
        ),
      )
      .toList();

  /// Example:
  /// _$[methodName]Event.add()
  Code _streamAddMethodInvoker(Expression argument) =>
      refer(generatedFieldName + '.add').call([argument]).code;

  Code buildBody() {
    List<Parameter> requiredParams = buildRequiredParameters();
    List<Parameter> optionalParams = buildOptionalParameters();
    if (requiredParams.isEmpty && optionalParams.isEmpty) {
      // Provide null if we don't have any parameters
      return _streamAddMethodInvoker(literalNull);
    }

    // Provide first if it's just one required parameter
    if (optionalParams.isEmpty && requiredParams.length == 1) {
      return _streamAddMethodInvoker(refer(requiredParams.first.name));
    }

    // Provide first if it's just one optional parameter
    if (requiredParams.isEmpty && optionalParams.length == 1) {
      return _streamAddMethodInvoker(refer(optionalParams.first.name));
    }

    List<Expression> positionalArguments = requiredParams
        .map((Parameter parameter) => refer(parameter.name))
        .toList();

    // Optional and not named are also positional
    for (Parameter param
        in optionalParams.where((Parameter param) => !param.named)) {
      positionalArguments.add(refer(param.name));
    }

    Map<String, Expression> namedArguments = {};
    for (Parameter param
        in optionalParams.where((Parameter param) => param.named)) {
      namedArguments[param.name] = refer(param.name);
    }

    return _streamAddMethodInvoker(
      refer('_${name.capitalize()}EventArgs').newInstance(
        positionalArguments,
        namedArguments,
      ),
    );
  }
}
