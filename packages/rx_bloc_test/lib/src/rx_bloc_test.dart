import 'dart:async';

import 'package:meta/meta.dart';
import 'package:quiver/testing/async.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:test/test.dart' as tester;

/// Creates a new test for a specific bloc [state].
/// [rxBlocTest] will create the specific test and initialize it's state
/// as well perform all the necessary operations based on provided parameters
/// before [expect]ing the desired values.
/// [rxBlocTest] will ensure that no additional states are emitted by closing
/// the states stream just before the evaluation.
///
/// [build] returns the bloc that will be used for testing as a Future. It
/// should be used for bloc initialization such as creation and dependency
/// injection.
///
/// [state] is the desired state of the bloc that is being tested. It is a
/// Stream of a specific testing type.
///
/// [act] is an optional callback that passes the bloc on which additional
/// actions can be applied. It should be used for adding events to the bloc.
///
/// [expect] is an `Iterable` of matchers which the bloc is expected to emit
/// after the [act] is executed.
///
/// [wait] is an optional `Duration` which is used to wait for async operations
/// within the `bloc` that take time to complete.
///
/// [skip] is an optional `int` that is used to skip a specific number of values
/// emitted by the [state]. The default value is 1 which skips the initial value
/// If the [skip] value is set to 0, it will include the initial value.
///
@isTest
void rxBlocTest<B extends RxBlocTypeBase, StateOutputType>(
  String message, {
  @required Future<B> Function() build,
  @required Stream<StateOutputType> Function(B) state,
  Future<void> Function(B) act,
  Iterable expect,
  Duration wait,
  int skip = 0,
}) {
  FakeAsync().run((async) {
    tester.test(message, () async {
      final bloc = await build();
      final checkingState = state(bloc);
      final states = <dynamic>[];
      final subscription = checkingState.skip(skip).listen(
        states.add,
        onError: (Object exception) {
          states.add(exception);
        },
      );
      await act?.call(bloc);

      if (wait != null) await Future<void>.delayed(wait);
      await Future<void>.delayed(Duration.zero);
      await subscription.cancel();
      if (expect != null) tester.expect(states, expect);
    });
  });
}
