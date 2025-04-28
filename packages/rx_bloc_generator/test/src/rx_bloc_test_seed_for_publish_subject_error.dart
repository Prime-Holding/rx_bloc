@Tags(['not-tests'])
library;

import 'package:rx_bloc/rx_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:source_gen_test/annotations.dart';
import 'package:test/test.dart';

@ShouldGenerate('/**\n'
    'Event `test` with type `PublishSubject` can not have a `seed` parameter.\n'
    '*/\n'
    '')
@RxBloc()
class CounterBloc {}

/// A contract class containing all events.
abstract class CounterBlocEvents {
  @RxBlocEvent(type: RxBlocEventType.publish, seed: 2)
  void test(int test);
}

/// A contract class containing all states for our multi state BloC.
abstract class CounterBlocStates {}
