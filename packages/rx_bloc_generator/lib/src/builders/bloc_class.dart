part of rx_bloc_generator;

class _BlocClass implements _RxBlocBuilder {
  _BlocClass(
    this.className,
    this.blocTypeClassName,
    this.eventClassName,
    this.stateClassName,
    this.eventsMethods,
    this.statesFields,
  );

  String className;

  String blocTypeClassName;

  String eventClassName;

  String stateClassName;

  final List<MethodElement> eventsMethods;

  final List<FieldElement> statesFields;

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
  @override
  String build() => Class((b) => b
    ..docs.addAll(<String>[
      '/// ${className} class - extended by the CounterBloc bloc',
      '/// {@nodoc}',
    ])
    ..abstract = true
    ..name = className
    ..extend = refer((RxBlocBase).toString())
    ..implements.addAll(<Reference>[
      refer(eventClassName),
      refer(stateClassName),
      refer(blocTypeClassName),
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

  /// A mapper that converts a [MethodElement] into an event [Field]
  List<Field> _eventFields() => eventsMethods.map((MethodElement method) {
        return Field(
          (b) => b
            // TODO(Diev): Add region comments
            ..modifier = FieldModifier.final$
            ..assignment = refer(method.eventStreamType)
                .newInstance(
                  method.seedPositionalArguments,
                  {},
                  method.streamTypeArguments,
                )
                .code
            ..name = method.eventFieldName,
        );
      }).toList();

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
            ..returns = refer(eventClassName)
            ..type = MethodType.getter
            ..name = 'events'
            ..lambda = true
            ..body = Code('this'),
        ),
        Method(
          (b) => b
            ..annotations.add(refer('override'))
            ..returns = refer(stateClassName)
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
