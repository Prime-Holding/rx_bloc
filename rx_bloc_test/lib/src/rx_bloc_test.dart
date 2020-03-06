import 'dart:async';

import 'package:meta/meta.dart';
import 'package:quiver/testing/async.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:test/test.dart' as tester;

@isTest
Future<void> rxBlocTest<B extends RxBlocBase, StateOutputType>(
  String message, {
  @required Future<B> Function() build,
  @required Stream<StateOutputType> Function(B) state,
  Future<void> Function(B) act,
  Iterable expect,
  Duration wait,
  int skip = 1,
}) {
  FakeAsync().run((async) {
    tester.test(message, () async {
      final bloc = await build();
      final checkingState = state(bloc);
      final List<StateOutputType> states = <StateOutputType>[];
      final subscription = checkingState.skip(skip).listen(states.add);
      await act?.call(bloc);

      if (wait != null) async.elapse(wait);
      subscription.cancel();
      if (expect != null) tester.expect(states, expect);
    });
  });
}
