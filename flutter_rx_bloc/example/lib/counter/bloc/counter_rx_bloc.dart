
import 'package:flutter/foundation.dart';
import 'package:rx_bloc/bloc/rx_bloc_base.dart';
import 'package:rxdart/rxdart.dart';

abstract class CounterBlocEvents {
  void increment();

  void decrement();
}

abstract class CounterBlocStates {
  Stream<String> get count;
}

abstract class CounterBlocType {
  CounterBlocEvents get events;

  CounterBlocStates get states;
}

abstract class $CounterBloc extends RxBlocBase
    implements CounterBlocEvents, CounterBlocStates, CounterBlocType {
  $CounterBloc() {
    //TODO dispose
    MergeStream([
      $incrementEvent.map((_) => _count.value+=1),
      $decrementEvent.map((_) => _count.value -= 1)
    ]).listen(_count.onAdd);
  }

  final _count = BehaviorSubject.seeded(0);
  final _compositeSubscription = CompositeSubscription();

  ///region Events

  ///region increment
  @protected
  final $incrementEvent = PublishSubject<void>();

  @override
  void increment() => $incrementEvent.add(null);

  ///endregion increment

  ///region decrement
  @protected
  final $decrementEvent = PublishSubject<void>();

  @override
  void decrement() => $decrementEvent.add(null);

  ///endregion decrement

  ///endregion Events

  ///region States

  ///region count
  Stream<String> _countState;

  @override
  Stream<String> get count => _countState ??= mapToCountState();

  @protected
  Stream<String> mapToCountState();

  ///endregion count

  ///endregion States

  @override
  void dispose() {
    _compositeSubscription.dispose();
    return super.dispose();
  }

  ///region Type

  @override
  CounterBlocEvents get events => this;

  @override
  CounterBlocStates get states => this;

  ///endregion Type

}

extension Arithmetic on Stream<int> {
  Stream<int> increment() => map((count) => count += 1);
  Stream<int> decrement() => map((count) => count -= 1);
}
