@Tags(['not-tests'])

import 'package:rx_bloc/rx_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:source_gen_test/annotations.dart';
import 'package:test/test.dart';

@ShouldGenerate('/**\n'
    'Event `test` seed value is missing or it is null.\n'
    '*/\n'
    '')
@RxBloc()
class CounterBloc {}

/// A contract class containing all events.
abstract class CounterBlocEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void test(int test);
}

/// A contract class containing all states for our multi state BloC.
abstract class CounterBlocStates {}
