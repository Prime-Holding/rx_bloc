part of rx_bloc_generator;

/// Class responsible for generating the end result file
/// containing the bloc boilerplate code.
///
/// Takes in a [viewModelElement] ClassElement that represents the class which
/// is annotated with the @RxBloc() annotation. Additionally, the class also
/// requires a [eventsElement] ClassElement which represents the events class
/// containing all the user-defined events of the bloc. The [statesElement]
/// ClassElement represents the states class containing all the user-defined
/// states of the bloc.
///
/// Note: This class generates a `part` file that has to be included
/// in the file containing the bloc in order to work properly.
class _RxBlocGenerator implements RxGeneratorContract {
  /// The default constructor
  _RxBlocGenerator(
    // TODO(Diev): Don't need it. We just need the name
    this.blocClass,
    this.eventsClass,
    this.statesClass, {
    this.contractClassName,
    this.partOfUrl,
  });

  /// The output buffer containing all the generated code
  final StringBuffer _output = StringBuffer();

  /// The class annotated with the @RxBloc() annotation
  final ClassElement blocClass;

  /// The class containing all the user-defined eventsClass
  final ClassElement eventsClass;

  /// The class containing all the user-defined statesClass
  final ClassElement statesClass;

  /// The [RxBlocName]BlocType class name
  final String contractClassName;

  /// The path that will be used for the part of statement
  final String partOfUrl;

  /// Generates the contents of the blocClass file
  @override
  String generate() {
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

  /// Generates the 'part of' section for the appropriate file
  ///
  /// Example:
  /// .. part of '[rx_bloc_name]_bloc.dart'
  ///
  // TODO(Diev): Use [Directive] instead once `part of` is supported
  // String _partOf() => Directive.partOf(partOfUrl);
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
                ..returns = refer(eventsClass.displayName)
                ..type = MethodType.getter,
            ),
            Method(
              (b) => b
                ..name = 'states'
                ..returns = refer(statesClass.displayName)
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
  ///    /// region Events
  ///    ...
  ///    /// region States
  ///    ...
  ///    /// region Type
  ///    ...
  ///    /// region Dispose of all the opened streams
  ///    ...
  /// }
  ///
  String _blocClass() => Class((b) => b
    ..docs.addAll(<String>[
      '/// \$${blocClass.displayName} class - extended by the CounterBloc bloc',
      '/// {@nodoc}',
    ])
    ..abstract = true
    ..name = '\$' + blocClass.displayName
    ..extend = refer((RxBlocBase).toString())
    ..implements.addAll(<Reference>[
      refer(eventsClass.displayName),
      refer(statesClass.displayName),
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
  List<String> _eventMethodsArgsClasses() => eventsClass.methods
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
                        parameter.type.toString(),
                      )
                      ..name = parameter.name,
                  ),
                ),
              ),
          ).toDartCodeString())
      .toList();

  /// Mapper that converts a [MethodElement] into an event [Field]
  List<Field> _eventFields() => eventsClass.methods
      .map((MethodElement method) => Field(
            (b) => b
              // TODO(Diev): Add region comments
              ..modifier = FieldModifier.final$
              // TODO(Diev): Add the stream type check - Subject or Behavior
              ..assignment = Code('PublishSubject<${method.argumentsType}>()')
              ..name = method.generatedFieldName,
          ))
      .toList();

  /// Mapper that converts a [MethodElement] into an event [Method]
  List<Method> _eventMethods() => eventsClass.methods
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

  /// Mapper that converts a [FieldElement] into an event [Field]
  List<Field> _stateFields() => statesClass.fields
      .map((FieldElement field) => Field(
            (b) => b
              // TODO(Diev): Add region comments
              ..type = refer(field.type.toString())
              ..name = field.generatedFieldName,
          ))
      .toList();

  /// Mapper that converts a [MethodElement] into an event [Method]
  List<Method> _stateGetMethods() => statesClass.fields
      .map(
        (FieldElement field) => Method(
          (b) => b
            // TODO(Diev): Add region comments
            ..type = MethodType.getter
            ..annotations.add(refer('override'))
            ..returns = refer(field.type.toString())
            ..name = field.name
            ..lambda = true
            ..body = refer(field.generatedFieldName)
                .assignNullAware(
                  refer(field.generatedMethodName).newInstance([]),
                )
                .code,
        ),
      )
      .toList();

  /// Mapper that converts a [MethodElement] into an event [Method]
  List<Method> _stateMethods() => statesClass.fields
      .map(
        (FieldElement field) => Method(
          (b) => b
            // TODO(Diev): Add region comments
            ..returns = refer(field.type.toString())
            ..name = field.generatedMethodName,
        ),
      )
      .toList();

  // Generates the 'events' and 'states' getter methods
  List<Method> _eventsAndStatesGetters() => [
        Method(
          (b) => b
            ..annotations.add(refer('override'))
            ..returns = refer(eventsClass.displayName)
            ..type = MethodType.getter
            ..name = 'events'
            ..lambda = true
            ..body = Code('this'),
        ),
        Method(
          (b) => b
            ..annotations.add(refer('override'))
            ..returns = refer(statesClass.displayName)
            ..type = MethodType.getter
            ..name = 'states'
            ..lambda = true
            ..body = Code('this'),
        ),
      ];

  // Builds the dispose method
  Method _disposeMethod() => Method.returnsVoid((b) => b
    ..annotations.add(refer('override'))
    ..name = 'dispose'
    ..body = CodeExpression(Block.of([
      ...eventsClass.methods.map(
        (MethodElement method) =>
            refer(method.generatedFieldName + '.close').call([]).statement,
      ),
      refer('super.dispose').call([]).statement,
    ])).code);
}
