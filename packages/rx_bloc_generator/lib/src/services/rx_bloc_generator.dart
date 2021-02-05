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
    this.blocClass,
    this.eventsClass,
    this.statesClass, {
    this.contractClassName,
    this.partOfUrl,
  }) : _statesClassGenerator = StatesGenerator(statesClass);

  /// The output buffer containing all the generated code
  final StringBuffer _output = StringBuffer();

  /// The class annotated with the @RxBloc() annotation
  final ClassElement blocClass;

  /// The class containing all the user-defined eventsClass
  final ClassElement eventsClass;

  /// The class containing all the user-defined statesClass
  final ClassElement statesClass;

  /// Delegate used to generate statesClass based on the statesClass class
  final StatesGenerator _statesClassGenerator;

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
  // TODO(Diev): Use [Directive] once `part of` is supported https://github.com/dart-lang/code_builder/pull/308
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
  String _blocClass() {
    return Class((b) => b
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
      ])
      ..methods.addAll(
        <Method>[
          ..._eventMethods(),
          // TODO(Diev): Implement the dispose method
        ],
      )).toDartCodeString();
  }

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
                      method.optionalParameters(toThis: true),
                    )
                    ..requiredParameters.addAll(
                      method.requiredParameters(toThis: true),
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
  List<Field> _eventFields() => eventsClass.methods.map((MethodElement method) {
        return Field(
          (b) => b
            // TODO(Diev): Add region comments
            // ..docs.add(
            //   '/// region ${method.name}Method',
            // )
            ..modifier = FieldModifier.final$
            // TODO(Diev): Add the stream type check - Subject or Behavior
            ..assignment = Code('PublishSubject<${method.argumentsType}>()')
            ..name = '_\$${method.name}Event',
        );
      }).toList();

  /// Mapper that converts a [MethodElement] into an event [Method]
  List<Method> _eventMethods() => eventsClass.methods
      .map(
        (MethodElement method) => Method(
          (b) => b
            // TODO(Diev): Add region comments
            // ..docs.add(
            //   '/// region ${method.name}Method',
            // )
            //     ..type = MethodType.v
            ..annotations.add(refer('override'))
            ..returns = refer('void')
            ..name = method.name
            ..requiredParameters.addAll(method.requiredParameters())
            ..optionalParameters.addAll(method.optionalParameters())
            ..lambda = true
            ..body = method.bodyCode(),
        ),
      )
      .toList();
}
