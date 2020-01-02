import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'rx_bloc_generator_for_annotation.dart';

Builder rxBlocGenerator(BuilderOptions options) {
  return LibraryBuilder(RxBlocGeneratorForAnnotation(),
      generatedExtension: ".g.dart");
}
