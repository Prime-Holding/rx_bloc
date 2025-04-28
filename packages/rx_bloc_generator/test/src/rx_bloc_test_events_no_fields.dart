@Tags(['not-tests'])
library;

import 'package:rx_bloc/rx_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:source_gen_test/annotations.dart';
import 'package:test/test.dart';

@ShouldGenerate('/**\n'
// ignore: lines_longer_than_80_chars
    'CounterBlocEvents should contain methods only, while noFields seems to be a field.\n'
    '*/\n'
    '')
@RxBloc()
class CounterBloc {}

/// A contract class containing all events.
abstract class CounterBlocEvents {
  late String noFields;
}

/// A contract class containing all states for our multi state BloC.
abstract class CounterBlocStates {}
