// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/repositories/counter_repository.dart';

part 'counter_bloc.rxb.g.dart';
part 'counter_bloc_extensions.dart';

/// A contract class containing all events.
abstract class CounterBlocEvents {
  /// Increment the count
  void increment();

  /// Decrement the count
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
  Stream<bool> get isLoading;

  /// Error messages
  Stream<String> get errors;
}

/// A BloC responsible for count calculations
@RxBloc()
class CounterBloc extends $CounterBloc {
  /// Default constructor
  CounterBloc(this._repository);

  final CounterRepository _repository;

  /// Map increment and decrement events to `count` state
  @override
  Stream<int> _mapToCountState() => Rx.merge<Result<int>>([
        // On increment.
        _$incrementEvent
            .switchMap((_) => _repository.increment().asResultStream()),
        // On decrement.
        _$decrementEvent
            .switchMap((_) => _repository.decrement().asResultStream()),
      ])
          // This automatically handles the error and loading state.
          .setResultStateHandler(this)
          // Provide success response only.
          .whereSuccess()
          //emit 0 as initial value
          .startWith(0);

  @override
  Stream<String> _mapToErrorsState() => errorState.toMessage();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}
