part of '../rx_bloc_generator.dart';

/// The generator.
class RxCoordinatorBlocGeneratorForAnnotation
    extends GeneratorForAnnotation<RxBlocCoordinatorAnnotation> {
  /// Allows creating via `const` as well as enforces immutability here.
  const RxCoordinatorBlocGeneratorForAnnotation();

  /// Generates comments to showcase investigation on how to analyze the code
  /// so we can identify all occurs of target annotation.
  /// Here are presented two approaches: the first one uses package:analyzer to
  /// inspect the hole project; the second uses BuildStep, but sadly can access
  /// only the current file and imported ones
  /// For testing we are using @RxBlocIgnoreState()
  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    var output = '\n';

    output += '\n// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n';
    output +=
        '// Using package:analyzer to get annotations for libraries - returns data for the entire project\n';
    output +=
        '// Should be possible to be used in combination with Macros - TO BE TESTED\n';
    output += '// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n';

    // Path to your project's lib directory
    final directory = Directory('./lib');

    // Recursively scan all Dart files in the directory
    final dartFiles = directory
        .listSync(recursive: true)
        .where((file) => file.path.endsWith('.dart'));

    List<String> analyzeFile(String dartCode) {
      // Parse the Dart code
      final result = parseString(content: dartCode);
      final compilationUnit = result.unit;

      // Create and use the visitor
      final visitor = _AnnotationFinderVisitor();
      compilationUnit.visitChildren(visitor);

      // Return collected annotations
      return visitor.annotations;
    }

    // Collect all annotations from the files
    final allAnnotations = <String, List<String>>{};

    // Analyze each Dart file
    for (final file in dartFiles) {
      final code = File(file.path).readAsStringSync();

      final annotations = analyzeFile(code);
      allAnnotations[file.path] = annotations;
    }

    // Print results
    allAnnotations.forEach((filePath, annotations) {
      output += '// In file: $filePath\n';
      print(' In file: $filePath');
      for (final annotation in annotations) {
        output += '//  Found annotation: $annotation\n';
        print('  Found annotation: $annotation');
      }
    });

    output +=
        '\n\n// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n';
    output +=
        '// Using BuildStep to analyze libraries - returns data only for the current file and imports\n';
    output += '// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n';

    // Helper function
    // Check if the library URI starts with "package:<your_package_name>"
    bool isLocalLibrary(LibraryElement library, BuildStep buildStep) {
      final uri = library.source.uri;
      final packageName = buildStep.inputId.package;
      return uri.scheme == 'package' && uri.pathSegments.first == packageName;
    }

    // Access all libraries available in the current file
    await for (var library in buildStep.resolver.libraries) {
      // Filter out all external imports as dart libraries etc.
      if (isLocalLibrary(library, buildStep)) {
        output += '// Local Library: ${library.source.uri}\n';

        // Check for fields with FieldAnnotation in that library
        final libraryReader = LibraryReader(library);
        for (final classElement in libraryReader.classes) {
          output +=
              ' //    ClassElement ${classElement.name} found in ${library.source.uri} \n';
          for (final field in classElement.fields) {
            // Check for a specific annotation
            // NB! The annotation is over field.getter do not search for annotation over the field itself
            bool isAnnot =
                field.getter?.hasAnnotation(RxBlocIgnoreState) ?? false;
            output +=
                ' //       Find field ${field.displayName} in class ${classElement.displayName} that has annotation RxBlocIgnoreState = $isAnnot\n';
          }
        }
      }
    }

    return _BuildCoordinatorController(data: output).generate();
  }
}

extension on Element {
  /// Checks if an element has a specific annotation type.
  bool hasAnnotation(Type type) {
    final checker = TypeChecker.fromRuntime(type);
    return checker.hasAnnotationOf(this);
  }
}

class _AnnotationFinderVisitor extends RecursiveAstVisitor<void> {
  // Store the results
  final List<String> annotations = [];

  @override
  void visitAnnotation(ast.Annotation node) {
    super.visitAnnotation(node);

    // Collect specific annotations by their name
    final annotationName = node.name.name;
    if (annotationName == 'RxBlocIgnoreState') {
      annotations.add(node.toString());
    }
  }
}
