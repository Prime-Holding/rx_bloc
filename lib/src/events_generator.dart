import 'package:analyzer/dart/element/element.dart';
import 'package:rx_bloc/annotation/rx_bloc_annotations.dart';
import 'package:rx_bloc_generator/utilities/utilities.dart';
import 'package:source_gen/source_gen.dart';

import 'package:rx_bloc_generator/utilities/string_extensions.dart';

/// Used for @RxBlocEvent() annotation checking
final _eventAnnotationChecker = TypeChecker.fromRuntime(RxBlocEvent);

/// EventsGenerator is a class responsible for generating all the user-defined
/// events of a bloc. It generates all the events delegated by the [RxBlocBuilder]
/// and handles appropriately errors that arise.
///
/// It takes in a [_eventsClass] ClassElement which represents the event class
/// from which it creates everything needed for the events to work.
class EventsGenerator {
  /// The output buffer containing generated events code
  StringBuffer _stringBuffer = StringBuffer();

  /// The class containing all the user-defined events
  ClassElement _eventsClass;

  EventsGenerator(this._eventsClass);

  /// Writes to output string buffer
  void _writeln([Object obj]) => _stringBuffer.writeln(obj);

  /// Generates all events based on the passed in events class
  String generate() {
    _writeln("\n\n  ///region Events");
    _writeln("\n");
    _writeln(_generateEvents());
    _writeln("\n  ///endregion Events");

    return _stringBuffer.toString();
  }

  /// Generates events string from methods while checking for any errors.
  String _generateEvents() {
    _eventsClass.fields.forEach((field) {
      var msg = '${_eventsClass.name} should contain methods only,';
      msg += ' while \'${field.name}\' seems to be a field.';
      logError(msg);
    });

    return _eventsClass.methods
        .checkForNonAbstractEvents()
        .mapToEvents()
        .join('\n');
  }
}

extension _CheckingEvents on List<MethodElement> {
  /// Performs a check and logs any non-abstract methods
  List<MethodElement> checkForNonAbstractEvents() {
    this.forEach((method) {
      if (!method.isAbstract)
        logError(
            'Event \'${method.definition}\' should not contain a body definition.');
    });
    return this;
  }
}

extension _MapToEvents on Iterable<MethodElement> {
  /// Maps all of methods to their events counterpart
  Iterable<String> mapToEvents() => map((method) {
        return '''
  ///region ${method.name}
 
  final _\$${method.name}Event = ${method.streamType};
  @override
  ${method.definition} => _\$${method.name}Event.add(${method.firstParameterName});
  ///endregion ${method.name}
  ''';
      });
}

extension _MethodExtensions on MethodElement {
  /// Returns the type of the first parameter as string
  String get firstParameterType =>
      "${parameters.isNotEmpty ? parameters.first.type : 'void'}";

  /// Returns the name of the first parameter as string
  String get firstParameterName =>
      "${parameters.isNotEmpty ? parameters.first.name : 'null'}";

  /// Returns the proper method definition (keeping as well
  /// default values and @required annotations)
  String get definition {
    var def = this.toString();
    this.parameterNames.forEach((paramName) {
      final param = this.getParameter(paramName);

      // Add required annotation before type
      if (param.hasRequired) {
        int index = def.indexOf(paramName);
        index = def.lastIndexOf(param.type.toString(), index);
        def = def.substring(0, index) + ' @required ' + def.substring(index);
      }

      // Add default value (if any)
      if (param.defaultValueCode != null) {
        int index = def.indexOf(paramName);
        def = def.substring(0, index) +
            def.substring(index, index + paramName.length) +
            ': ${param.defaultValueCode}' +
            def.substring(index + paramName.length);
      }
    });

    return def;
  }

  /// Returns the parameter instance of a method by its [paramName]
  ParameterElement getParameter(String paramName) {
    return this.parameters.firstWhere((param) => param.name == paramName);
  }

  /// Returns the list of all parameter names of a method
  List<String> get parameterNames =>
      this.parameters.map((param) => param.name).toList();

  /// Returns the type of stream checking for @RxBlocEvent() annotation
  /// and handling errors if any
  String get streamType {
    // Check if it is a behaviour event
    if (_eventAnnotationChecker.hasAnnotationOfExact(this)) {
      final annotation = _eventAnnotationChecker.firstAnnotationOfExact(this);
      final isBehaviorSubject =
          annotation.getField('type').toString().contains('behaviour');

      if (isBehaviorSubject) {
        final seedField = annotation.getField('seed');

        // Check for any errors regarding the seed value
        if (!seedField.isNull) {
          final firstParam = firstParameterType.replaceAll(' ', '');
          final typeAsString = seedField.toString().getTypeFromString();
          // Check for seed value mismatch
          if (typeAsString != firstParam) {
            final msg = StringBuffer();
            msg.write('Type mismatch between seed type and ');
            msg.write('expected parameter type:\n');
            msg.write('\tExpected: \'$firstParam\'');
            msg.write('\tGot: \'$typeAsString\'');
            logError(msg.toString());
          }
        } else
          logError('Seed value can not be null.');

        final seedValue = seedField.toString().convertToValidString();
        return 'BehaviorSubject.seeded($seedValue)';
      }
    }

    // Fallback case is a publish event
    return 'PublishSubject<$firstParameterType>()';
  }
}
