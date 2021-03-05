part of rx_bloc_generator;

/// Supported types of streams
class _BlocEventStreamTypes {
  /// Constants feel more comfortable than strings
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

/// It is the main [DartFormatter]
extension _SpecExtensions on Spec {
  String toDartCodeString() => DartFormatter().format(
        accept(
          DartEmitter(Allocator.none, false, true),
        ).toString(),
      );
}

extension _StateFieldElement on FieldElement {
  String get stateFieldName => '_${name}State';

  String get stateMethodName => '_mapTo${name.capitalize()}State';
}

extension _EventMethodElement on MethodElement {
  /// The event field name in the generated file
  String get eventFieldName => '_\$${name}Event';

  /// The name of the arguments class that will be generated if
  /// the event contains more than one parameter
  String get eventArgumentsClassName => '_${name.capitalize()}EventArgs';

  /// Is the the [RxBlocEvent.seed] annotation is provided
  bool get hasSeedAnnotation =>
      _computedRxBlocEventAnnotation != null &&
      _computedRxBlocEventAnnotation?.getField('seed') is DartObject;

  /// Provides the stream generic type
  ///
  /// Example:
  /// if `fetchNews(int param)` then -> PublishSubject<int>
  /// if `fetchNews(String param)` then -> PublishSubject<String>
  /// if `fetchNews(int p1, int p2)` then -> PublishSubject<_FetchNewsEventArgs>
  List<Reference> get streamTypeArguments =>
      !isBehavior ? [refer(publishSubjectGenericType)] : [];

  /// Provides the [BehaviorSubject.seeded] arguments as [List] of [Expression]
  /// Throws an [_RxBlocGeneratorException] if a seed is provided but
  /// the stream is not  [RxBlocEventType.behaviour]
  List<Expression> get seedPositionalArguments {
    if (hasSeedAnnotation && !isBehavior) {
      throw _RxBlocGeneratorException('Event `$name` with type `PublishSubject`'
          ' can not have a `seed` parameter.');
    }

    return isBehavior ? [_seededArgument] : [];
  }

  /// Provides the [BehaviorSubject.seeded] arguments as an [Expression]
  Expression get _seededArgument {
    Iterable<String> seedArgumentsMatch = RegExp(r'(?<=seed: ).*(?=\)|,)')
        .allMatches(_rxBlocEventAnnotation?.toSource() ?? '')
        .map<String>((m) => m.group(0) ?? '');

    if (seedArgumentsMatch.isEmpty) {
      throw _RxBlocGeneratorException(
          'Event `$name` seed value is missing or it is null.');
    }

    String seedArguments = seedArgumentsMatch.toString();
    return refer(
      '${isUsingArgumentClass && !seedArguments.contains('(const') ? 'const ' : ''}'
      '${seedArguments.substring(1, seedArguments.length - 1)}',
    );
  }

  /// Provides the stream type based on the [RxBlocEventType] annotation
  String get eventStreamType => isBehavior
      ? _BlocEventStreamTypes.behavior + (hasSeedAnnotation ? '.seeded' : '')
      : _BlocEventStreamTypes.publish;

  /// Provides the first annotation as [ElementAnnotation] if exists
  ElementAnnotation? get _eventAnnotation =>
      // TODO(Diev): Check if
      metadata.isNotEmpty && metadata.first is ElementAnnotation
          ? metadata.first
          : null;

  /// Provides the [RxBlocEvent] annotation as [DartObject] if exists
  DartObject? get _computedRxBlocEventAnnotation =>
      _rxBlocEventAnnotation?.computeConstantValue();

  /// Provides the [RxBlocEvent] annotation as [ElementAnnotation] if exists
  ElementAnnotation? get _rxBlocEventAnnotation => _eventAnnotation
              ?.computeConstantValue()
              ?.type
              ?.getDisplayString(withNullability: true) ==
          (RxBlocEvent).toString()
      ? _eventAnnotation
      : null;

  /// Is the event stream type a [BehaviorSubject]
  bool get isBehavior =>
      _computedRxBlocEventAnnotation.toString().contains('behaviour');

  /// Use argument class when the event's parameters are more than 1
  bool get isUsingArgumentClass => parameters.length > 1;

  /// Provides the stream type based on the number of the parameters
  /// Example:
  /// if `fetchNews(int param)` then -> int
  /// if `fetchNews(String param)` then -> String
  /// if `fetchNews(int param1, int param2)` -> _FetchNewsEventArgs
  String get publishSubjectGenericType {
    if (isUsingArgumentClass) {
      return eventArgumentsClassName;
    }
    return parameters.isNotEmpty
        // The only parameter's type
        ? parameters.first.type.getDisplayString(withNullability: true)
        // Default type
        : 'void';
  }

  /// Builds the stream body
  /// Example 1:
  /// _${EventMethodName}EventName.add(param)
  ///
  /// Example 2:
  /// _${EventMethodName}EventName.add(_MethodEventArgs(param1, param2))
  ///
  Code buildBody() {
    List<Parameter> requiredParams = parameters.whereRequired().clone();
    List<Parameter> optionalParams = parameters.whereOptional().clone();

    if (requiredParams.isEmpty && optionalParams.isEmpty) {
      // Provide null if we don't have any parameters
      return _callStreamAddMethod(literalNull);
    }

    // Provide the first if it's just one required parameter
    if (optionalParams.isEmpty && requiredParams.length == 1) {
      return _callStreamAddMethod(refer(requiredParams.first.name));
    }

    // Provide the first if it's just one optional parameter
    if (requiredParams.isEmpty && optionalParams.length == 1) {
      return _callStreamAddMethod(refer(optionalParams.first.name));
    }

    return _callStreamAddMethod(
      refer('_${name.capitalize()}EventArgs').newInstance(
        _positionalArguments,
        _namedArguments,
      ),
    );
  }

  /// Example:
  /// _${methodName}Event.add()
  Code _callStreamAddMethod(Expression argument) =>
      refer('$eventFieldName.add').call([argument]).code;

  /// Provides the event's positional arguments as a [Map] of [Expression]
  List<Expression> get _positionalArguments => parameters
      .where((ParameterElement parameter) =>
          parameter.isNotOptional || parameter.isOptionalPositional)
      .map(
        (ParameterElement parameter) => refer(parameter.name),
      )
      .toList();

  /// Provides the event's name arguments as a [Map] of [Expression]
  Map<String, Expression> get _namedArguments {
    List<Parameter> params = parameters.clone();

    // Only named are not positional parameters
    Map<String, Expression> namedArguments = {};
    for (Parameter param in params.where((Parameter param) => param.named)) {
      namedArguments[param.name] = refer(param.name);
    }
    // For methods with more than 1 parameters provide the new param class
    return namedArguments;
  }
}

extension _ListParameterElementWhere on List<ParameterElement> {
  Iterable<ParameterElement> whereRequired() => where(
      (parameter) => !parameter.isNamed && !parameter.isOptionalPositional);

  Iterable<ParameterElement> whereOptional() =>
      where((parameter) => parameter.isOptionalPositional || parameter.isNamed);
}

extension _ListParameterElementClone on Iterable<ParameterElement> {
  List<Parameter> clone({bool toThis = false}) => map(
        (ParameterElement parameter) => Parameter(
          (b) => b
            ..toThis = toThis
            ..required = parameter.isRequiredNamed
            ..defaultTo = parameter.defaultValueCode != null
                ? Code(parameter.defaultValueCode)
                : null
            ..named = parameter.isNamed
            ..name = parameter.name
            ..type = toThis
                ? null // We don't need the type in the constructor
                : refer(parameter.getTypeDisplayName()),
        ),
      ).toList();
}

extension _ParameterElementToString on ParameterElement {
  String getTypeDisplayName() => type.getDisplayString(withNullability: true);
}
