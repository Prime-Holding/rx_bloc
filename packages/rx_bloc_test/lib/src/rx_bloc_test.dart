import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:meta/meta.dart';
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
  required Future<B> Function() build,
  required Stream<StateOutputType> Function(B) state,
  required Iterable expect,
  Future<void> Function(B)? act,
  Duration? wait,
  int skip = 0,
}) =>
    tester.test(message, () async {
      final bloc = await build();
      final checkingState = state(bloc).skip(skip).asBroadcastStream();

      if (wait != null) await Future<void>.delayed(wait);

      tester.expect(
        checkingState,
        tester.emitsInOrder(expect),
      );

      await act?.call(bloc);
    });

/// Creates a new test for a specific bloc [state].
/// [rxBlocFakeAsyncTest] will create the specific test and initialize it's
/// state as well perform all the necessary operations based on provided
/// parameters before [expect]ing the desired values.
///
/// [rxBlocFakeAsyncTest] will ensure that no additional states are emitted by
/// closing the states stream just before the evaluation.
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
/// Also contain instance of FakeAsync, which provide a way to fire all
/// asynchronous events that are scheduled for that time period without
/// actually needing the test to wait for real time to elapse.
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
void rxBlocFakeAsyncTest<B extends RxBlocTypeBase, StateOutputType>(
  String message, {
  required B Function() build,
  required Stream<StateOutputType> Function(B) state,
  required Iterable expect,
  void Function(B, FakeAsync fakeAsync)? act,
  Duration? wait,
  int skip = 0,
}) =>
    tester.test(message, () {
      fakeAsync((async) {
        final bloc = build();
        final checkingState = state(bloc).skip(skip).asBroadcastStream();

        if (wait != null) {
          async.elapse(wait);
        }

        tester.expect(
          checkingState,
          tester.emitsInOrder(expect),
        );

        act?.call(bloc, async);

        async.flushMicrotasks();
      });
    });
