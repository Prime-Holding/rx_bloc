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
class RxBlocGenerator implements GeneratorContract{
  /// The default constructor
  RxBlocGenerator(
    this.blocClass,
    this.eventsClass,
    this.statesClass,
  )   : _eventsClassGenerator =
            EventsGenerator(eventsClass, blocClass.source.contents.data),
        _statesClassGenerator = StatesGenerator(statesClass);

  /// The output buffer containing all the generated code
  final StringBuffer _output = StringBuffer();

  /// The class annotated with the @RxBloc() annotation
  final ClassElement blocClass;

  /// The class containing all the user-defined eventsClass
  final ClassElement eventsClass;

  /// The class containing all the user-defined statesClass
  final ClassElement statesClass;

  /// Delegate used to generate eventsClass based on the eventsClass class
  final EventsGenerator _eventsClassGenerator;

  /// Delegate used to generate statesClass based on the statesClass class
  final StatesGenerator _statesClassGenerator;

  /// Writes to output string buffer
  void _writeln([Object obj]) => _output.writeln(obj);

  String get _contractClassName => blocClass.displayName + 'Type';

  /// Generates the contents of the blocClass file
  @override
  String generate() {
    <String>[
      _partOf(), // part of [bloc_name]_bloc.dart
      _blocContract(), // abstract [RxBlocName]BlocType
      _blocClass(),
      _eventMethodsArgsClasses(),
    ].forEach(_output.writeln);

    return _output.toString();
  }

  /// Generates the 'part of' section for the appropriate file
  ///
  /// Example:
  /// .. part of '[rx_bloc_name]_bloc.dart'
  ///
  String _partOf() =>
      "part of '${Uri.tryParse(blocClass.location.components.first)}';";

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
            '/// ${_contractClassName} class used for blocClass event and '
                'state access from widgets',
            '/// {@nodoc}',
          ])
          ..abstract = true
          ..name = blocClass.displayName + 'Type'
          ..extend = refer((RxBlocTypeBase).toString())
          ..fields.addAll(<Field>[
            Field(
              (b) => b
                ..name = 'eventsClass'
                ..type = refer(eventsClass.displayName + ' get '),
            ),
            Field(
              (b) => b
                ..name = 'statesClass'
                ..type = refer(statesClass.displayName + ' get '),
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
    return Class(
      (b) => b
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
          refer(_contractClassName),
        ])
    ).toDartCodeString();
    var comment = '\n/// \$${blocClass.displayName} class - extended by the ';
    comment += '${blocClass.displayName} blocClass';
    _writeln('\n');
    _writeln(comment);
    _noDocAnnotation();
    _writeln('abstract class \$${blocClass.displayName} extends RxBlocBase');
    _writeln('\n    implements');
    _writeln('\n        ${eventsClass.displayName},');
    _writeln('\n        ${statesClass.displayName},');
    _writeln('\n        ${blocClass.displayName}Type {');
    _writeln(_eventsClassGenerator.generate());
    _writeln(_statesClassGenerator.generate());
    _writeln('\n  ///region Type');
    _writeln('\n  @override');
    _writeln('\n  ${eventsClass.displayName} get eventsClass => this;');
    _writeln('\n');
    _writeln('\n  @override');
    _writeln('\n  ${statesClass.displayName} get statesClass => this;');
    _writeln('\n  ///endregion Type');
    _generateDisposeMethod();
    _writeln('\n}\n');
    _writeln(_eventsClassGenerator.generateArgumentClasses());
  }

  /// Generates the dispose method for the blocClass
  void _generateDisposeMethod() {
    _writeln('\n/// Dispose of all the opened streams');
    _writeln('\n@override');
    _writeln('\nvoid dispose(){');

    eventsClass.methods.forEach(
      (method) => _writeln('_\$${method.name}Event.close();'),
    );
    _writeln('super.dispose();');
    _writeln('}');
  }

  void _comment(String comment, {String prefix = ''}) =>
      _output.writeln('/// ' + prefix + comment);

  void _noDocAnnotation() => _comment('{@nodoc}');

  /// Generates class like..
  /// .. class _EventMethodArgs {
  /// ..    _EventMethodArgs({this.argExample});
  /// ..    final int argExample;
  /// .. }
  // TODO(Diev): To be implemented
  String _eventMethodsArgsClasses() => '';
}
