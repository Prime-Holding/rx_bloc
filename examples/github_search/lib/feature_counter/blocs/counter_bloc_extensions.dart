// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

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
