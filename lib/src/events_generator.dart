import 'package:analyzer/dart/element/element.dart';
import 'package:rx_bloc/annotation/rx_bloc_annotations.dart';
import 'package:rx_bloc_generator/utilities/string_extensions.dart';
import 'package:rx_bloc_generator/utilities/utilities.dart';
import 'package:source_gen/source_gen.dart';

/// Used for @RxBlocEvent() annotation checking
final _eventAnnotationChecker = TypeChecker.fromRuntime(RxBlocEvent);

/// EventsGenerator is a class responsible for generating all the user-defined
/// events of a bloc. It generates all the events delegated by the [RxBlocBuilder]
/// and handles appropriately errors that arise.
///
/// It takes in a [_eventsClass] ClassElement which represents the event class
/// from which it creates everything needed for the events to work.
/// It also takes a [_sourceCode] String containing the source code from the
/// file in which the [_eventsClass] resides.
class EventsGenerator {
  /// The output buffer containing generated events code
  final StringBuffer _stringBuffer = StringBuffer();

  /// The class containing all the user-defined events
  final ClassElement _eventsClass;

  /// The source code of the file where the events class resides
  final String _sourceCode;

  EventsGenerator(this._eventsClass, this._sourceCode);

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

  /// Generates argument classes for events containing more than one parameter
  String generateArgumentClasses() {
    StringBuffer _argClassString = StringBuffer();
    final _multiParameterEvents =
        _eventsClass.methods.where((method) => method.parameters.length > 1);
    if (_multiParameterEvents.isEmpty) return '';

    // Generate argument classes section only if there is at least one class
    _argClassString.writeln('/// region Argument classes\n');
    for (var method in _multiParameterEvents) {
      _argClassString.writeln('/// region ${method.argumentsClassName} class');
      _argClassString.writeln(_generateArgumentClass(method));
      _argClassString
          .writeln('/// endregion ${method.argumentsClassName} class');
    }
    _argClassString.writeln('\n/// endregion Argument classes\n');
    return _argClassString.toString();
  }

  /// Generates argument class for the [method], which contains more than one parameter
  String _generateArgumentClass(MethodElement method) {
    StringBuffer _buffer = StringBuffer();
    final className = method.argumentsClassName;
    final paramNames = method.parameterNames;
    _buffer.writeln('\n/// {@nodoc}');
    _buffer.writeln('class $className {\n');
    // Create all the parameters first
    paramNames.forEach((paramName) {
      final param = method.getParameter(paramName);
      _buffer.writeln('final ${param.type.toString()} $paramName;');
    });
    // Create the constant constructor
    _buffer.writeln('\nconst $className({');
    paramNames.forEach((paramName) => _buffer.writeln('this.$paramName,'));
    _buffer.writeln('});');
    _buffer.writeln('\n}');
    return _buffer.toString();
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
        .mapToEvents(_mapMethodToEvent)
        .join('\n');
  }

  /// Mapper that converts a [method] into a event
  String _mapMethodToEvent(MethodElement method) {
    final methodDefinition = method.definition;
    final streamType = _getStreamType(method);

    return '''
  ///region ${method.name}
 
  final _\$${method.name}Event = $streamType;
  @override
  $methodDefinition => _\$${method.name}Event.add(${method.streamTypeParameters});
  ///endregion ${method.name}
  ''';
  }

  /// Returns the type of stream checking the [method] for
  /// @RxBlocEvent() annotation and handling errors if any.
  String _getStreamType(MethodElement method) {
    final hasRxEventAnnotation =
        _eventAnnotationChecker.hasAnnotationOfExact(method);
    final annotation = _eventAnnotationChecker.firstAnnotationOfExact(method);
    final isBehaviorSubject =
        annotation?.getField('type').toString().contains('behaviour') ?? false;
    if (!hasRxEventAnnotation || !isBehaviorSubject)
      return 'PublishSubject<${method.streamTypeBasedOnParameters}>()';

    // The method has a RxBlocEvent annotation

    String seedValue = '';
    if (method.parameters.length > 1) {
      // Seeding with EventArgs class for that specific method
      final argClassName = method.argumentsClassName;
      final userParams = _getSeedParametersForMethod(method) ?? '';
      String params = userParams.addComaAtEndIfNone();
      // Append missing default and required parameters
      method.parameterNames.forEach((paramName) {
        final param = method.getParameter(paramName);
        if (!params.contains(paramName)) {
          // Append missing default value
          final defVal = param.defaultValueCode;
          if (defVal != null) params += ' $paramName : $defVal,';
        }
        // Display error for required parameter
        if (param.hasRequired && !params.contains(paramName)) {
          String msg = 'Requred parameter \'$paramName\' from \'$argClassName';
          msg += '\' needs to be specified in the seed.';
          logError(msg);
        }
      });
      seedValue = '$argClassName($params)';
    } else {
      // Seeding with only one parameter
      final seedField = annotation.getField('seed');

      // Check for any errors regarding the seed value
      if (!seedField.isNull) {
        final firstParam =
            method.streamTypeBasedOnParameters.replaceAll(' ', '');
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

      seedValue = seedField.toString().convertToValidString();
    }
    return 'BehaviorSubject.seeded($seedValue)';
  }

  /// Gets the seed parameters from source code,
  /// for the [method] annotated with @RxBlocEvent()
  String _getSeedParametersForMethod(MethodElement method) {
    final methodStartIndex =
        _sourceCode.indexOf('${method.returnType.toString()} ${method.name}(');
    final annotationStartIndex =
        _sourceCode.lastIndexOf('@RxBlocEvent', methodStartIndex);
    final analysisString =
        _sourceCode.substring(annotationStartIndex, methodStartIndex);

    // Check if there is a seed parameter
    if (!analysisString.contains('seed:')) {
      logError('Seed value can not be null.');
      return null;
    }
    if (!analysisString.contains(method.argumentsClassName)) {
      logError('Invalid seed value for event \'${method.definition}\'.');
      return null;
    }

    final bracketIndex =
        analysisString.indexOf('(', analysisString.indexOf('seed:') + 5) + 1;
    final bracketIndexEnd =
        analysisString.getIndexOfClosingBracket(bracketIndex);
    return analysisString.substring(bracketIndex, bracketIndexEnd);
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
  /// Maps all of methods to their events counterpart using a [mapper] function
  /// The [mapper] function takes in a [MethodElement] and returns a [String].
  Iterable<String> mapToEvents(Function(MethodElement) mapper) =>
      map((method) => mapper(method));
}

extension _MethodExtensions on MethodElement {
  /// The name of the arguments class that will be generated if
  /// the event contains more than one parameter
  String get argumentsClassName => '_${this.name.capitalize()}EventArgs';

  /// Returns the stream type based on the number of the parameters of the method
  String get streamTypeBasedOnParameters {
    if (this.parameters.length > 1) return this.argumentsClassName;
    return "${parameters.isNotEmpty ? parameters.first.type : 'void'}";
  }

  /// Returns the method parameters in a format usable for streams
  String get streamTypeParameters {
    if (this.parameters.length > 1) {
      var str = '${this.argumentsClassName}(';
      this
          .parameterNames
          .forEach((paramName) => str += ' $paramName:$paramName,');
      str += ')';
      return str;
    }
    return "${parameters.isNotEmpty ? parameters.first.name : 'null'}";
  }

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
}

extension _StringExtensions on String {
  /// Returns index of closing brackets balancing other brackets along
  int getIndexOfClosingBracket(int startIndex) {
    final str = this.substring(startIndex);
    int normal = 1;
    int angle = 0;
    int curly = 0;

    int i = 0;
    while ((normal != 0 || angle != 0 || curly != 0) && i < str.length) {
      var ch = str[i];
      if (ch == '(') normal++;
      if (ch == ')') normal--;
      if (ch == '<') angle++;
      if (ch == '>') angle--;
      if (ch == '{') curly++;
      if (ch == '}') curly--;
      i++;
    }
    if (i == str.length) return -1;
    i--;
    return i + startIndex;
  }

  /// Appends a comma at the end of a string if there's none, if
  /// the string has a valid length. Else, returns an empty string
  String addComaAtEndIfNone() {
    String str = this.trim();
    if (str.length == 0) return '';
    str += str[str.length - 1] != ',' ? ',' : '';
    return str;
  }
}
