import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'mvvm_generator.dart';

Builder mvvmGenerator(BuilderOptions options) {
  return LibraryBuilder(MVVMGenerator(), generatedExtension: ".g.dart");
}
