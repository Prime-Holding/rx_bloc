import 'package:analyzer/dart/element/element.dart';

class ViewModelGenerator {
  final StringBuffer _stringBuffer = StringBuffer();
  final ClassElement viewModelElement;
  final ClassElement inputElement;
  final ClassElement outputElement;

  ViewModelGenerator(
    this.viewModelElement,
    this.inputElement,
    this.outputElement,
  );

  // helper functions
  void _writeln([Object obj]) => _stringBuffer.writeln(obj);

  String generate() {
    _generateImports();
    _generateTypeClass();
    _generateViewModelClass();
    return _stringBuffer.toString();
  }

  void _generateImports() => [
        "'${viewModelElement.location.components.first}'",
        "'package:flutter/cupertino.dart'",
        "'package:rxdart/rxdart.dart'",
        "'package:clean_mvvm/view_model/base_view_model.dart'"
      ].forEach((import) => _writeln("import $import;"));

  void _generateTypeClass() {
    _writeln("\nabstract class ${viewModelElement.displayName}Type {");
    _writeln("\n  ${viewModelElement.displayName}Input get input;");
    _writeln("\n  ${viewModelElement.displayName}Output get output;");
    _writeln("\n}");
  }

  void _generateViewModelClass() {
    _writeln("\n");
    _writeln(
        "\nabstract class \$${viewModelElement.displayName} extends BaseViewModel");
    _writeln("\n    implements");
    _writeln("\n        ${viewModelElement.displayName}Input,");
    _writeln("\n        ${viewModelElement.displayName}Output,");
    _writeln("\n        ${viewModelElement.displayName}Type {");
    _writeln("\n  ///region Inputs");
    _writeln("\n");
    _writeln(_generateInputs());
    _writeln("\n  ///endregion Inputs");
    _writeln("\n  ///region Outputs");
    _writeln("\n");
    _writeln(_generateOutputs());
    _writeln("\n  ///endregion Outputs");
    _writeln("\n  ///region Type");
    _writeln("\n  @override");
    _writeln("\n  ${viewModelElement.displayName}Input get input => this;");
    _writeln("\n");
    _writeln("\n  @override");
    _writeln("\n  ${viewModelElement.displayName}Output get output => this;");
    _writeln("\n  ///endregion Type");
    _writeln("\n}");
  }

  String _generateInputs() => inputElement.methods.mapToInputs().join('\n');

  String _generateOutputs() => outputElement.accessors
      .filterViewModelIgnoreOutput()
      .map((element) => element.variable)
      .mapToOutputs()
      .join('\n');
}

extension _MapToInputs on Iterable<MethodElement> {
  List<String> mapToInputs() => map((method) => '''
  ///region ${method.name}
  final \$${method.name}Input = PublishSubject<${method.firstParameterType}>();

  @override
  ${method.definition} => \$${method.name}Input.add(${method.firstParameterName});
  ///endregion ${method.name}
  ''');
}

extension _MapToOutputs on Iterable<PropertyInducingElement> {
  List<String> mapToOutputs() => map((fieldElement) => '''
  ///region ${fieldElement.displayName}
  ${fieldElement.type} _${fieldElement.displayName};

  @override
  ${fieldElement.type} get ${fieldElement.displayName} => _${fieldElement.displayName} ??= init${fieldElement.displayName.capitalize()}();

  @protected
  ${fieldElement.type} init${fieldElement.displayName.capitalize()}();
  ///endregion ${fieldElement.displayName}
  ''');
}

extension _FilterViewModelIgnoreOutput on List<PropertyAccessorElement> {
  List<PropertyAccessorElement> filterViewModelIgnoreOutput() =>
      where((fieldElement) {
        if (fieldElement.metadata.isEmpty) {
          return true;
        }

        return !fieldElement.metadata.any((annotation) {
          //TODO: find a better way
          return annotation.element
              .toString()
              .contains('ViewModelIgnoreOutput');
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
