@Tags(['not-tests'])

import 'package:rx_bloc/rx_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:source_gen_test/annotations.dart';
import 'package:test/test.dart';

@ShouldGenerate('/**\n'
    'State noMethods should not contain a body definition.\n'
    '*/\n'
    '')
@RxBloc()
class CounterBloc {}

/// A contract class containing all events.
abstract class CounterBlocEvents {}

/// A contract class containing all states for our multi state BloC.
abstract class CounterBlocStates {
  String get noMethods => 'noMethods';
}
