import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../repositories/counter_repository.dart';

part 'counter_bloc.rxb.g.dart';

/// This BloC and its event and state contracts usually
/// resides in `counter_bloc.dart`
/// A contract class containing all events.
abstract class CounterBlocEvents {
  /// Increment the count event.
  void increment();

  /// Decrement the count event.
  void decrement();
}

/// A contract class containing all states for our multi state BloC.
abstract class CounterBlocStates {
  /// The count of the Counter
  ///
  /// It can be controlled by executing [CounterBlocEvents.increment] and
  /// [CounterBlocEvents.decrement]
  ///
  Stream<int> get count;

  /// Loading state
  Stream<LoadingWithTag> get isLoadingWithTag;

  /// Loading state
  Stream<bool> get isLoading;

  /// Loading state
  Stream<bool> get isLoadingDecrement;

  /// Error messages
  Stream<String> get errors;

  /// ... state n
  /// You can have as many states as you need.
  /// You're not limited to 1 state for a bloc class.
}

/// A RX `CounterBloc` which maps multiple events with multiple states.
class CounterBloc extends $CounterBloc {
  CounterBloc(this._repository);

  final CounterRepository _repository;

  static String incrementTag = 'increment';
  static String decrementTag = 'decrement';

  /// Map increment and decrement events to `count` state.
  @override
  Stream<int> _mapToCountState() => Rx.merge<Result<int>>([
        // On increment.
        _$incrementEvent.flatMap(
            (_) => _repository.increment().asResultStream(tag: incrementTag)),
        // On decrement.
        _$decrementEvent.flatMap(
            (_) => _repository.decrement().asResultStream(tag: decrementTag)),
      ])
          // This automatically handles the error and loading state.
          .setResultStateHandler(this)
          // Provide success response only.
          .whereSuccess()
          //emit 0 as initial value
          .startWith(0);

  /// Transform any exception into a readable string.
  @override
  Stream<String> _mapToErrorsState() => errorWithTagState
      .map((result) => 'tag: ${result.tag} with message ${result.exception}');

  @override
  Stream<LoadingWithTag> _mapToIsLoadingWithTagState() => loadingWithTagState;

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<bool> _mapToIsLoadingDecrementState() =>
      loadingForTagState(CounterBloc.decrementTag);
}
