import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'counter_bloc.rxb.g.dart';

/// This BloC and its event and state contracts usually
/// resides in counter_bloc.dart

/// A contract class containing all events.
abstract class CounterBlocEvents {
  /// Increment the count
  void setCount(int count);

  /// Decrement the count
  void setLoading();

  /// Decrement the count
  void setError(Exception error);
}

/// A contract class containing all states for our multi state BloC.
abstract class CounterBlocStates {
  /// The count of the Counter
  ///
  /// It can be controlled by executing [CounterBlocEvents.increment] and
  /// [CounterBlocEvents.decrement]
  ///
  Stream<Result<int>> get count;

  /// Loading state
  Stream<bool> get isLoading;

  /// Error messages
  Stream<String> get errors;
}

/// A BloC responsible for count calculations
@RxBloc()
class CounterBloc extends $CounterBloc {
  CounterBloc({Result<int>? initialState}) {
    if (initialState != null) {
      _countSubject.add(initialState);
    }

    Rx.merge([
      _$setCountEvent.map((event) => Result<int>.success(1)),
      _$setLoadingEvent.map((event) => Result<int>.loading()),
      _$setErrorEvent.map((event) => Result<int>.error(event)),
    ])
        .setResultStateHandler(this)
        .doOnData(print)
        .bind(_countSubject)
        .disposedBy(_compositeSubscription);
  }

  final _countSubject = BehaviorSubject<Result<int>>();

  /// Map increment and decrement events to `count` state
  @override
  Stream<Result<int>> _mapToCountState() => _countSubject;

  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((Exception error) => error.toString());

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}
