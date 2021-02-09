part of rx_bloc_generator;

class _BlocEventStreamTypes {
  static const String publish = 'PublishSubject';
  static const String behavior = 'BehaviorSubject';
}

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

extension _SeedValue on DartObject {
  dynamic get value =>
      toBoolValue() ??
      toIntValue() ??
      toDoubleValue() ??
      toStringValue() ??
      toListValue() ??
      toMapValue();
}

extension _StateFieldElement on FieldElement {
  String get stateFieldName => '_${name}State';

  String get stateMethodName => '_mapTo${name.capitalize()}State';
}

extension _EventMethodElement on MethodElement {
  String get eventFieldName => '_\$${name}Event';

  /// The name of the arguments class that will be generated if
  /// the event contains more than one parameter
  String get eventArgumentsClassName => '_${name.capitalize()}EventArgs';

  bool get hasSeedAnnotation =>
      _rxBlocEventAnnotation != null &&
      _rxBlocEventAnnotation.getField('seed') is DartObject;

  List<Expression> get streamPositionalArguments {
    if (hasSeedAnnotation && !isBehavior) {
      throw _RxBlocGeneratorException('Event `$name` with type `PublishSubject`'
          ' can not have a `seed` parameter.');
    }

    return isBehavior ? [_seededValue] : [];
  }

  List<Reference> get streamNamedArguments =>
      !isBehavior ? [refer(argumentsType)] : [];

  List<Expression> _positionalArguments([bool withValues = false]) => parameters
          .where((ParameterElement parameter) =>
              parameter.isNotOptional || parameter.isOptionalPositional)
          .map(
        (ParameterElement parameter) {
          return refer(
              withValues ? parameter.defaultValueCode : parameter.name);
        },
      ).toList();

  Map<String, Expression> get _namedArguments {
    List<Parameter> optionalParams = buildOptionalParameters();
    // Only named are not positional parameters
    Map<String, Expression> namedArguments = {};
    for (Parameter param
        in optionalParams.where((Parameter param) => param.named)) {
      namedArguments[param.name] = refer(param.name);
    }
    // For methods with more than 1 parameters provide the new param class
    return namedArguments;
  }

  Expression get _seededValue {
    if (parameters.length > 1) {
      // For methods with more than 1 parameters provide the new param class
      return refer(eventArgumentsClassName).newInstance(
        _positionalArguments(),
        _namedArguments,
      );
    }

    if (_rxBlocEventAnnotation.getField('seed').isNull) {
      throw _RxBlocGeneratorException(
          'Event `$name` seed value is missing or can not be null.');
    }

    return refer(_rxBlocEventAnnotation.getField('seed')?.value.toString());
  }

  /// Returns the stream type based on the [RxBlocEvent] annotation
  String get eventStreamType => isBehavior
      ? _BlocEventStreamTypes.behavior + (hasSeedAnnotation ? '.seeded' : '')
      : _BlocEventStreamTypes.publish;

  DartObject get _eventAnnotation =>
      metadata.isNotEmpty && metadata.first is ElementAnnotation
          ? metadata.first.computeConstantValue()
          : null;

  DartObject get _rxBlocEventAnnotation =>
      _eventAnnotation?.type?.getDisplayString(withNullability: false) ==
              (RxBlocEvent).toString()
          ? _eventAnnotation
          : null;

  /// Is it the event a [BehaviorSubject] stream
  bool get isBehavior =>
      _rxBlocEventAnnotation?.toString()?.contains('behaviour') ?? false;

  /// Returns the event type based on the number of the parameters of the method
  String get argumentsType {
    if (parameters.length > 1) {
      // For methods with more than 1 parameters provide the new param class
      return eventArgumentsClassName;
    }
    return parameters.isNotEmpty
        // The only parameter's type
        ? parameters.first.type.getDisplayString(withNullability: false)
        // Default type
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
      refer(eventFieldName + '.add').call([argument]).code;

  Code buildBody() {
    List<Parameter> requiredParams = buildRequiredParameters();
    List<Parameter> optionalParams = buildOptionalParameters();
    if (requiredParams.isEmpty && optionalParams.isEmpty) {
      // Provide null if we don't have any parameters
      return _streamAddMethodInvoker(literalNull);
    }

    // Provide the first if it's just one required parameter
    if (optionalParams.isEmpty && requiredParams.length == 1) {
      return _streamAddMethodInvoker(refer(requiredParams.first.name));
    }

    // Provide the first if it's just one optional parameter
    if (requiredParams.isEmpty && optionalParams.length == 1) {
      return _streamAddMethodInvoker(refer(optionalParams.first.name));
    }

    return _streamAddMethodInvoker(
      refer('_${name.capitalize()}EventArgs').newInstance(
        _positionalArguments(),
        _namedArguments,
      ),
    );
  }
}
