import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'view_model_annotations.dart';
import 'view_model_generator.dart';

class MVVMGenerator extends GeneratorForAnnotation<ViewModel> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    // return early if annotation is used for a none class element
    if (element is! ClassElement) return null;

    final classElement = element as ClassElement;

    final libraryReader = LibraryReader(classElement.library);

    final inputElement = libraryReader.classes.firstWhere(
        (classElement) => classElement.displayName.contains('Input'));

    final outputElement = libraryReader.classes.firstWhere(
        (classElement) => classElement.displayName.contains('Output'));

    //TODO: Handle missing input/output classes
    return ViewModelGenerator(classElement, inputElement, outputElement)
        .generate();
  }
}
