{{> licence.dart }}

// ignore_for_file: lines_longer_than_80_chars

part of 'counter_bloc.dart';

/// TODO: Here you can add the implementation details of your BloC or any stream extensions you might need.
/// Thus, the BloC will contain only declarations, which improves the readability and the maintainability.

/// Combines data emitted from all events to produce stream of Result<Count>
/// and load the initial data.
extension _CounterExtension on CounterBloc {
  Stream<Result<Count>> get countState => Rx.merge<Result<Count>>([
        // On increment.
        _$incrementEvent.switchMap((_) => _repository
            .increment()
            .asResultStream(tag: CounterBloc.tagIncrement)),
        // On decrement.
        _$decrementEvent.switchMap((_) => _repository
            .decrement()
            .asResultStream(tag: CounterBloc.tagDecrement)),
        // Get current value
        _$reloadEvent.startWith(null).switchMap((_) => _repository
            .getCurrent()
            .asResultStream(tag: CounterBloc.tagReload)),
      ]);
}
