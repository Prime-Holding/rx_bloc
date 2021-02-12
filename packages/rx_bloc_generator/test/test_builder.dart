import 'package:build/build.dart';
import 'package:rx_bloc_generator/rx_bloc_generator.dart';
import 'package:source_gen/source_gen.dart';

/// The entry point of the RxBloc code generation
Builder testBuilder(BuilderOptions options) {
  return LibraryBuilder(
    const RxBlocGeneratorForAnnotation(),
    generatedExtension: '.rxb.test.g.dart',
  );
}
