import 'package:analyzer/dart/element/element.dart';

class RxBlocGenerator {
  final StringBuffer _stringBuffer = StringBuffer();
  final ClassElement viewModelElement;
  final ClassElement eventsElement;
  final ClassElement statesElement;

  RxBlocGenerator(
    this.viewModelElement,
    this.eventsElement,
    this.statesElement,
  );

  // helper functions
  void _writeln([Object obj]) => _stringBuffer.writeln(obj);

  String generate() {
    _generateImports();
    _generateTypeClass();
    _generateBlocClass();
    return _stringBuffer.toString();
  }

  void _generateImports() => [
        "'${viewModelElement.location.components.first}'",
        "'package:flutter/cupertino.dart'",
        "'package:rxdart/rxdart.dart'",
        "'package:rx_bloc/bloc/rx_bloc_base.dart'"
      ].forEach((import) => _writeln("import $import;"));

  void _generateTypeClass() {
    _writeln("\nabstract class ${viewModelElement.displayName}Type extends RxBlocTypeBase {");
    _writeln("\n  ${eventsElement.displayName} get events;");
    _writeln("\n  ${statesElement.displayName} get states;");
    _writeln("\n}");
  }

  void _generateBlocClass() {
    _writeln("\n");
    _writeln(
        "\nabstract class \$${viewModelElement.displayName} extends RxBlocBase");
    _writeln("\n    implements");
    _writeln("\n        ${eventsElement.displayName},");
    _writeln("\n        ${statesElement.displayName},");
    _writeln("\n        ${viewModelElement.displayName}Type {");
    _writeln("\n  ///region Events");
    _writeln("\n");
    _writeln(_generateEvents());
    _writeln("\n  ///endregion Events");
    _writeln("\n  ///region States");
    _writeln("\n");
    _writeln(_generateStates());
    _writeln("\n  ///endregion States");
    _writeln("\n  ///region Type");
    _writeln("\n  @override");
    _writeln("\n  ${eventsElement.displayName} get events => this;");
    _writeln("\n");
    _writeln("\n  @override");
    _writeln("\n  ${statesElement.displayName} get states => this;");
    _writeln("\n  ///endregion Type");
    _writeln("\n}");
  }

  String _generateEvents() => eventsElement.methods.mapToEvents().join('\n');

  String _generateStates() => statesElement.accessors
      .filterRxBlocIgnoreState()
      .map((element) => element.variable)
      .mapToStates()
      .join('\n');
}

extension _MapToEvents on Iterable<MethodElement> {
  Iterable<String> mapToEvents() => map((method) => '''
  ///region ${method.name}
  @protected
  final \$${method.name}Event = PublishSubject<${method.firstParameterType}>();

  @override
  ${method.definition} => \$${method.name}Event.add(${method.firstParameterName});
  ///endregion ${method.name}
  ''');
}

extension _MapToStates on Iterable<PropertyInducingElement> {
  Iterable<String> mapToStates() => map((fieldElement) => '''
  ///region ${fieldElement.displayName}
  ${fieldElement.type} _${fieldElement.displayName}State;

  @override
  ${fieldElement.type} get ${fieldElement.displayName} => _${fieldElement.displayName}State ??= mapTo${fieldElement.displayName.capitalize()}State();

  @protected
  ${fieldElement.type} mapTo${fieldElement.displayName.capitalize()}State();
  ///endregion ${fieldElement.displayName}
  ''');
}

extension _FilterViewModelIgnoreState on List<PropertyAccessorElement> {
  Iterable<PropertyAccessorElement> filterRxBlocIgnoreState() =>
      where((fieldElement) {
        if (fieldElement.metadata.isEmpty) {
          return true;
        }

        return !fieldElement.metadata.any((annotation) {
//TODO: find a better way
          return annotation.element.toString().contains('RxBlocIgnoreState');
        });
      });
}

extension _Capitalize on String {
  String capitalize() => "${this[0].toUpperCase()}${this.substring(1)}";
}

extension _FirstParameter on MethodElement {
  String get firstParameterType =>
      "${parameters.isNotEmpty ? parameters.first.type : 'void'}";

  String get firstParameterName =>
      "${parameters.isNotEmpty ? parameters.first.name : 'null'}";

  String get definition {
    if (this.parameters.isEmpty) {
      return "$returnType $name()";
    }

    return "$returnType $name(${parameters.first.type} ${parameters.first.name})";
  }
}
