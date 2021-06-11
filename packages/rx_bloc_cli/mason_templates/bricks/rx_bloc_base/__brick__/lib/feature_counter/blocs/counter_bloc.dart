// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/models/count.dart';
import '../../base/repositories/counter_repository.dart';

part 'counter_bloc.rxb.g.dart';
part 'counter_bloc_extensions.dart';

/// A contract class containing all events.
abstract class CounterBlocEvents {
  /// Increment the count
  void increment();

  /// Decrement the count
  void decrement();

  /// Get the current count
  void current();
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

  /// Result state
  Stream<Result<Count>> get counterResult;
}

/// A BloC responsible for count calculations
@RxBloc()
class CounterBloc extends $CounterBloc {
  /// Bloc constructor
  CounterBloc(this._repository) {
    Rx.merge<Result<Count>>([
      // On increment.
      _$incrementEvent
          .switchMap((_) => _repository.increment().asResultStream()),
      // On decrement.
      _$decrementEvent
          .switchMap((_) => _repository.decrement().asResultStream()),
      // Get current value
      _$currentEvent
          .switchMap((_) => _repository.getCurrent().asResultStream()),
      // Get initial value
      _repository.getCurrent().asResultStream(),
    ]).bind(_lastFetchedCount).disposedBy(_compositeSubscription);
  }

  final CounterRepository _repository;
  final _lastFetchedCount = BehaviorSubject<Result<Count>>();

  @override
  Stream<int> _mapToCountState() =>
      _lastFetchedCount.whereSuccess().map((count) => count.value);

  @override
  Stream<String> _mapToErrorsState() =>
      Rx.merge<Exception>([_lastFetchedCount.whereError().mapFromDio()])
          .toMessage()
          .asBroadcastStream();

  @override
  Stream<bool> _mapToIsLoadingState() =>
      Rx.merge<bool>([_lastFetchedCount.map((value) => value is ResultLoading)])
          .asBroadcastStream();

  @override
  Stream<Result<Count>> _mapToCounterResultState() => _lastFetchedCount;

  @override
  void dispose() {
    _lastFetchedCount.close();
    super.dispose();
  }
}
