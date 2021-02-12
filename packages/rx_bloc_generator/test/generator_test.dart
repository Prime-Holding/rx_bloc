import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_generator/rx_bloc_generator.dart';
import 'package:source_gen_test/src/build_log_tracking.dart';
import 'package:source_gen_test/src/init_library_reader.dart';
import 'package:source_gen_test/src/test_annotated_classes.dart';


// Command: pub run test generator_test.dart
Future<void> main() async {
  final reader = await initializeLibraryReaderForDirectory(
    'test/src',
    'rx_bloc_test.dart',
  );
  initializeBuildLogTracking();
  testAnnotatedElements<RxBloc>(
    reader,
    const RxBlocGeneratorForAnnotation(),
  );
}
