part of rx_bloc_generator;

/// Using the `code_builder` this class provides the generated file as string
class _RxBlocCodeBuilder {
  _RxBlocCodeBuilder(
    String blocClassName,
    this.eventsClassName,
    this.eventsMethods,
    this.statesClassName,
    this.statesFields,
    this.partOfUrl,
  )   : blocClassName = '\$${blocClassName}',
        contractClassName = '${blocClassName}Type';

  /// The $[RxBlocName] class name
  final String blocClassName;

  /// The [RxBlocName]Events class name
  final String eventsClassName;

  final List<MethodElement> eventsMethods;

  /// The [RxBlocName]States class name
  final String statesClassName;

  final List<FieldElement> statesFields;

  /// The [RxBlocName]BlocType class name
  final String contractClassName;

  /// The path that will be used for the part of statement
  final String partOfUrl;

  /// Generates the contents of the blocClass file
  String build() {
    /// The output buffer containing all the generated code
    final StringBuffer _output = StringBuffer();

    <String>[
      // part of [bloc_name]_bloc.dart
      _partOf(),

      // abstract class [RxBlocName]BlocType
      _blocContract(),

      // abstract class $[RxBlocName]Bloc
      _blocClass(),

      // class _[EventMethodName]EventArgs
      ..._eventMethodsArgsClasses(),
    ].forEach(_output.writeln);

    return _output.toString();
  }

  /// Generates the 'part of' directive
  ///
  /// Example:
  /// .. part of '[rx_bloc_name]_bloc.dart'
  ///
  // TODO(Diev): Use [Directive] instead once `part of` is supported
  // Example: String _partOf() => Directive.partOf(partOfUrl);
  String _partOf() => "part of '${partOfUrl}';";

  /// Generates the type class for the blocClass
  ///
  ///  Example:
  ///  abstract class [RxBlocName]BlocType extends RxBlocTypeBase {
  ///    [RxBlocName]BlocEvents get events;
  ///    [RxBlocName]BlocStates get states;
  ///  }
  ///
  String _blocContract() => Class(
        (b) => b
          ..docs.addAll(<String>[
            '/// ${contractClassName} class used for blocClass event and '
                'state access from widgets',
            '/// {@nodoc}',
          ])
          ..abstract = true
          ..name = contractClassName
          ..extend = refer((RxBlocTypeBase).toString())
          ..methods.addAll(<Method>[
            Method(
              (b) => b
                ..name = 'events'
                ..returns = refer(eventsClassName)
                ..type = MethodType.getter,
            ),
            Method(
              (b) => b
                ..name = 'states'
                ..returns = refer(statesClassName)
                ..type = MethodType.getter,
            ),
          ]),
      ).toDartCodeString();

  /// Generates the contents of the blocClass
  ///
  /// Example:
  /// abstract class $[RxBlocName]Bloc extends RxBlocBase
  ///    implements [RxBlocName]BlocEvents, [RxBlocName]BlocStates, [RxBlocName]BlocType {
  ///
  ///    /// Events
  ///    ...
  ///    /// States
  ///    ...
  ///    /// Type - events, states getters
  ///    ...
  ///    /// Dispose of all the opened streams
  ///    ...
  /// }
  ///
  String _blocClass() => Class((b) => b
    ..docs.addAll(<String>[
      '/// ${blocClassName} class - extended by the CounterBloc bloc',
      '/// {@nodoc}',
    ])
    ..abstract = true
    ..name = blocClassName
    ..extend = refer((RxBlocBase).toString())
    ..implements.addAll(<Reference>[
      refer(eventsClassName),
      refer(statesClassName),
      refer(contractClassName),
    ])
    ..fields.addAll(<Field>[
      ..._eventFields(),
      ..._stateFields(),
    ])
    ..methods.addAll(
      <Method>[
        ..._eventMethods(),
        ..._stateGetMethods(),
        ..._stateMethods(),
        ..._eventsAndStatesGetters(),
        _disposeMethod(),
      ],
    )).toDartCodeString();

  /// Generates class like..
  /// .. class _EventMethodArgs {
  /// ..    _EventMethodArgs({this.argExample});
  /// ..    final int argExample;
  /// .. }
  List<String> _eventMethodsArgsClasses() => eventsMethods
      .where((MethodElement method) => method.parameters.length > 1)
      .map((MethodElement method) => Class(
            (b) => b
              ..name = '_${method.name.capitalize()}EventArgs'
              ..constructors.add(
                Constructor(
                  (b) => b
                    ..constant = true
                    ..optionalParameters.addAll(
                      method.buildOptionalParameters(toThis: true),
                    )
                    ..requiredParameters.addAll(
                      method.buildRequiredParameters(toThis: true),
                    ),
                ),
              )
              ..fields.addAll(
                method.parameters.map(
                  (ParameterElement parameter) => Field(
                    (b) => b
                      ..modifier = FieldModifier.final$
                      ..type = refer(
                        parameter.type.getDisplayString(withNullability: false),
                      )
                      ..name = parameter.name,
                  ),
                ),
              ),
          ).toDartCodeString())
      .toList();

  /// A mapper that converts a [MethodElement] into an event [Field]
  List<Field> _eventFields() => eventsMethods.map((MethodElement method) {
        return Field(
          (b) => b
            // TODO(Diev): Add region comments
            ..modifier = FieldModifier.final$
            ..assignment = refer(method.eventStreamType)
                .newInstance(
                  method.streamPositionalArguments,
                  {},
                  method.streamNamedArguments,
                )
                .code
            ..name = method.eventFieldName,
        );
      }).toList();

  /// A mapper that converts a [MethodElement] into an event [Method]
  List<Method> _eventMethods() => eventsMethods
      .map(
        (MethodElement method) => Method.returnsVoid(
          (b) => b
            // TODO(Diev): Add region comments
            ..annotations.add(refer('override'))
            ..name = method.name
            ..requiredParameters.addAll(method.buildRequiredParameters())
            ..optionalParameters.addAll(method.buildOptionalParameters())
            ..lambda = true
            ..body = method.buildBody(),
        ),
      )
      .toList();

  /// A mapper that converts a [FieldElement] into an event [Field]
  List<Field> _stateFields() => statesFields
      .map((FieldElement field) => Field(
            (b) => b
              // TODO(Diev): Add region comments
              ..type =
                  refer(field.type.getDisplayString(withNullability: false))
              ..name = field.stateFieldName,
          ))
      .toList();

  /// A mapper that converts a [MethodElement] into an event [Method]
  List<Method> _stateGetMethods() => statesFields
      .map(
        (FieldElement field) => Method(
          (b) => b
            // TODO(Diev): Add region comments
            ..type = MethodType.getter
            ..annotations.add(refer('override'))
            ..returns =
                refer(field.type.getDisplayString(withNullability: false))
            ..name = field.name
            ..lambda = true
            ..body = refer(field.stateFieldName)
                .assignNullAware(
                  refer(field.stateMethodName).newInstance([]),
                )
                .code,
        ),
      )
      .toList();

  /// A mapper that converts a [MethodElement] into an event [Method]
  List<Method> _stateMethods() => statesFields
      .map(
        (FieldElement field) => Method(
          (b) => b
            // TODO(Diev): Add region comments
            ..returns = refer(
              field.type.getDisplayString(withNullability: false),
            )
            ..name = field.stateMethodName,
        ),
      )
      .toList();

  // Generates the 'events' and 'states' getter methods
  List<Method> _eventsAndStatesGetters() => [
        Method(
          (b) => b
            ..annotations.add(refer('override'))
            ..returns = refer(eventsClassName)
            ..type = MethodType.getter
            ..name = 'events'
            ..lambda = true
            ..body = Code('this'),
        ),
        Method(
          (b) => b
            ..annotations.add(refer('override'))
            ..returns = refer(statesClassName)
            ..type = MethodType.getter
            ..name = 'states'
            ..lambda = true
            ..body = Code('this'),
        ),
      ];

  // Builds the dispose method
  Method _disposeMethod() => Method.returnsVoid(
        (b) => b
          ..annotations.add(refer('override'))
          ..name = 'dispose'
          ..body = CodeExpression(Block.of([
            ...eventsMethods.map(
              (MethodElement method) =>
                  refer(method.eventFieldName + '.close').call([]).statement,
            ),
            refer('super.dispose').call([]).statement,
          ])).code,
      );
}
