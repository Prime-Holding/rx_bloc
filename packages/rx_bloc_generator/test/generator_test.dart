import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_generator/rx_bloc_generator.dart';
import 'package:source_gen_test/src/build_log_tracking.dart';
import 'package:source_gen_test/src/init_library_reader.dart';
import 'package:source_gen_test/src/test_annotated_classes.dart';

// Command: pub run test generator_test.dart
Future<void> main() async {
  initializeBuildLogTracking();

  testAnnotatedElements<RxBloc>(
    await initializeLibraryReaderForDirectory(
      'test/src',
      'rx_bloc_test.dart',
    ),
    const RxBlocGeneratorForAnnotation(),
  );

  testAnnotatedElements<RxBloc>(
    await initializeLibraryReaderForDirectory(
      'test/src',
      'rx_bloc_test_events_missing.dart',
    ),
    const RxBlocGeneratorForAnnotation(),
  );

  testAnnotatedElements<RxBloc>(
    await initializeLibraryReaderForDirectory(
      'test/src',
      'rx_bloc_test_events_no_fields.dart',
    ),
    const RxBlocGeneratorForAnnotation(),
  );

  testAnnotatedElements<RxBloc>(
    await initializeLibraryReaderForDirectory(
      'test/src',
      'rx_bloc_test_states_missing.dart',
    ),
    const RxBlocGeneratorForAnnotation(),
  );

  testAnnotatedElements<RxBloc>(
    await initializeLibraryReaderForDirectory(
      'test/src',
      'rx_bloc_test_states_no_methods.dart',
    ),
    const RxBlocGeneratorForAnnotation(),
  );

  testAnnotatedElements<RxBloc>(
    await initializeLibraryReaderForDirectory(
      'test/src',
      'rx_bloc_test_states_no_body_definition.dart',
    ),
    const RxBlocGeneratorForAnnotation(),
  );

  testAnnotatedElements<RxBloc>(
    await initializeLibraryReaderForDirectory(
      'test/src',
      'rx_bloc_test_class_only.dart',
    ),
    const RxBlocGeneratorForAnnotation(),
  );

  testAnnotatedElements<RxBloc>(
    await initializeLibraryReaderForDirectory(
      'test/src',
      'rx_bloc_test_long_state_method.dart',
    ),
    const RxBlocGeneratorForAnnotation(),
  );

  testAnnotatedElements<RxBloc>(
    await initializeLibraryReaderForDirectory(
      'test/src',
      'rx_bloc_test_seed_for_publish_subject_error.dart',
    ),
    const RxBlocGeneratorForAnnotation(),
  );

  testAnnotatedElements<RxBloc>(
    await initializeLibraryReaderForDirectory(
      'test/src',
      'rx_bloc_test_behaviour_subject_no_seed.dart',
    ),
    const RxBlocGeneratorForAnnotation(),
  );
}
