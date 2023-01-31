import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:test/test.dart' as tester;

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
