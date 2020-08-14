import 'package:analyzer/dart/element/element.dart';
import 'package:rx_bloc_generator/src/events_generator.dart';
import 'package:rx_bloc_generator/src/states_generator.dart';

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
/// Note: This class generates a [part] file that has to be included
/// in the file containing the bloc in order to work properly.
class RxBlocGenerator {
  /// The output buffer containing all the generated code
  final StringBuffer _stringBuffer = StringBuffer();

  /// The class annotated with the @RxBloc() annotation
  final ClassElement viewModelElement;

  /// The class containing all the user-defined events
  final ClassElement eventsElement;

  /// The class containing all the user-defined states
  final ClassElement statesElement;

  /// Delegate used to generate events based on the events class
  final EventsGenerator _eventsGenerator;

  /// Delegate used to generate states based on the states class
  final StatesGenerator _statesGenerator;

  RxBlocGenerator(
    this.viewModelElement,
    this.eventsElement,
    this.statesElement,
  )   : _eventsGenerator = EventsGenerator(
            eventsElement, viewModelElement.source.contents.data),
        _statesGenerator = StatesGenerator(statesElement);

  /// Writes to output string buffer
  void _writeln([Object obj]) => _stringBuffer.writeln(obj);

  /// Generates the contents of the bloc file
  String generate() {
    _generatePartOf();
    _generateTypeClass();
    _generateBlocClass();
    return _stringBuffer.toString();
  }

  void _generateNoDocString() {
    _writeln('/// {@nodoc}');
  }

  /// Generates the 'part of' section for the appropriate file
  void _generatePartOf() {
    final uri = Uri.tryParse(viewModelElement.location.components.first);
    _writeln("part of '${uri.pathSegments.last}';");
  }

  /// Generates the type class for the bloc
  void _generateTypeClass() {
    String comment =
        "\n/// ${viewModelElement.displayName}Type class used for bloc";
    comment += " event and state access from widgets";
    _writeln(comment);
    _generateNoDocString();
    _writeln(
        "abstract class ${viewModelElement.displayName}Type extends RxBlocTypeBase {");
    _writeln("\n  ${eventsElement.displayName} get events;");
    _writeln("\n  ${statesElement.displayName} get states;");
    _writeln("\n}");
  }

  /// Generates the contents of the bloc
  void _generateBlocClass() {
    String comment =
        "\n/// \$${viewModelElement.displayName} class - extended by the ";
    comment += "${viewModelElement.displayName} bloc";
    _writeln("\n");
    _writeln(comment);
    _generateNoDocString();
    _writeln(
        "abstract class \$${viewModelElement.displayName} extends RxBlocBase");
    _writeln("\n    implements");
    _writeln("\n        ${eventsElement.displayName},");
    _writeln("\n        ${statesElement.displayName},");
    _writeln("\n        ${viewModelElement.displayName}Type {");
    _writeln(_eventsGenerator.generate());
    _writeln(_statesGenerator.generate());
    _writeln("\n  ///region Type");
    _writeln("\n  @override");
    _writeln("\n  ${eventsElement.displayName} get events => this;");
    _writeln("\n");
    _writeln("\n  @override");
    _writeln("\n  ${statesElement.displayName} get states => this;");
    _writeln("\n  ///endregion Type");
    _generateDisposeMethod();
    _writeln("\n}\n");
    _writeln(_eventsGenerator.generateArgumentClasses());
  }

  /// Generates the dispose method for the bloc
  void _generateDisposeMethod() {
    _writeln("\n/// Dispose of all the opened streams");
    _writeln("void dispose(){");

    eventsElement.methods.forEach((method) {
      _writeln("_\$${method.name}Event.close();");
    });
    _writeln("super.dispose();");
    _writeln("}");
  }
}
