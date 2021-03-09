import 'package:rx_bloc/rx_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:source_gen_test/annotations.dart';

@ShouldGenerate(r'''
part of 'rx_bloc_test.dart';
''')
@RxBloc()
class CounterBloc {}

/// A contract class containing all events.
abstract class CounterBlocEvents {
  void withTwoNamedRequired({required String nr1, required String nr2});
}

/// A contract class containing all states for our multi state BloC.
abstract class CounterBlocStates {}
