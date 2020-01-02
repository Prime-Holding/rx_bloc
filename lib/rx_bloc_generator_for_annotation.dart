import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:source_gen/source_gen.dart';

import 'rx_bloc_generator.dart';

class RxBlocGeneratorForAnnotation extends GeneratorForAnnotation<RxBloc> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    // return early if annotation is used for a none class element
    if (element is! ClassElement) return null;

    final classElement = element as ClassElement;

    final libraryReader = LibraryReader(classElement.library);

    final eventsClass = libraryReader.classes.firstWhere(
        (classElement) => classElement.displayName.contains('Events'));

    final statesClass = libraryReader.classes.firstWhere(
        (classElement) => classElement.displayName.contains('States'));

    //TODO: Handle missing input/output classes
    return RxBlocGenerator(classElement, eventsClass, statesClass).generate();
  }
}
