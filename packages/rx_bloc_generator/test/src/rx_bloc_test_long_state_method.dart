@Tags(['not-tests'])

import 'package:rx_bloc/rx_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:source_gen_test/annotations.dart';
import 'package:test/test.dart';

@ShouldGenerate(r'''
part of 'rx_bloc_test_long_state_method.dart';

/// Used as a contractor for the bloc, events and states classes
/// @nodoc
abstract class CounterBlocType extends RxBlocTypeBase {
  CounterBlocEvents get events;
  CounterBlocStates get states;
}

/// [$CounterBloc] extended by the [CounterBloc]
/// @nodoc
abstract class $CounterBloc extends RxBlocBase
    implements CounterBlocEvents, CounterBlocStates, CounterBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// The state of [someVeryVeryLongLongProperty] implemented in
  /// [_mapToSomeVeryVeryLongLongPropertyState]
  late final Stream<void> _someVeryVeryLongLongPropertyState =
      _mapToSomeVeryVeryLongLongPropertyState();

  @override
  Stream<void> get someVeryVeryLongLongProperty =>
      _someVeryVeryLongLongPropertyState;

  Stream<void> _mapToSomeVeryVeryLongLongPropertyState();

  @override
  CounterBlocEvents get events => this;

  @override
  CounterBlocStates get states => this;

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }
}
''')
@RxBloc()
class CounterBloc {
  CounterBloc(this.test);

  final String test;
}

/// A contract class containing all events.
abstract class CounterBlocEvents {}

/// A contract class containing all states for our multi state BloC.
abstract class CounterBlocStates {
  Stream<void> get someVeryVeryLongLongProperty;
}
