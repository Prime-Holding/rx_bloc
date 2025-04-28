@Tags(['not-tests'])
library;

import 'package:rx_bloc/rx_bloc.dart';
import 'package:source_gen_test/source_gen_test.dart';
import 'package:test/test.dart';

@ShouldGenerate(r'''
part of 'rx_bloc_test_generic_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// @nodoc
abstract class CounterBlocType extends RxBlocTypeBase {
  CounterBlocEvents get events;
  CounterBlocStates get states;
}

/// [$CounterBloc<T, R>] extended by the [CounterBloc<T, R>]
/// @nodoc
abstract class $CounterBloc<T, R> extends RxBlocBase
    implements CounterBlocEvents, CounterBlocStates, CounterBlocType {
  final _compositeSubscription = CompositeSubscription();

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
class CounterBloc<T, R> {}

abstract class CounterBlocEvents {}

abstract class CounterBlocStates {}
