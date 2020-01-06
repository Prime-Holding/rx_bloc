import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

//import 'counter_bloc.g.dart';

abstract class CounterBlocEvents {
  void increment();

  void decrement();
}

abstract class CounterBlocStates {
  Stream<String> get count;
}

/// Each Bloc needs to be annotated with the @rxBloc as this will
@RxBloc()
class CounterBloc {
  final _count = BehaviorSubject.seeded(0);
  final _compositeSubscription = CompositeSubscription();

  CounterBloc() {
//    MergeStream([
//      $incrementEvent.map((_) => _count.value += 1),
//      $decrementEvent.map((_) => _count.value -= 1)
//    ]).bind(_count).disposedBy(_compositeSubscription);
  }

  @override
  Stream<String> mapToCountState() => _count.mapToCount();

//  @override
//  dispose() {
//    _compositeSubscription.dispose();
//    return super.dispose();
//  }
}

extension CountState on Stream<int> {
  Stream<String> mapToCount() => map((count) => count.toString());
}
