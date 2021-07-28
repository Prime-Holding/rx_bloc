// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/extensions/stream_extensions.dart';
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
  void reload();
}

/// A contract class containing all states for our multi state BloC.
abstract class CounterBlocStates {
  /// Loading state of the bloc
  ///
  /// It is true when the bloc is waiting for the repository to returns data
  /// or throws an Exception
  Stream<LoadingWithTag> get isLoading;

  /// Error state of the bloc
  ///
  /// Emits an error message, when the repository throws an Exception
  Stream<String> get errors;

  /// The count of the Counter
  ///
  /// It can be controlled by executing [CounterBlocEvents.increment] and
  /// [CounterBlocEvents.decrement]
  ///
  Stream<int> get count;
}

/// A BloC responsible for count calculations
@RxBloc()
class CounterBloc extends $CounterBloc {
  /// Bloc constructor
  CounterBloc({required CounterRepository repository})
      : _repository = repository;

  final CounterRepository _repository;

  /// Increment action
  static const tagIncrement = 'Increment';

  /// Decrement action
  static const tagDecrement = 'Decrement';

  /// Reload action
  static const tagReload = 'Reload';

  @override
  Stream<String> _mapToErrorsState() => errorState.mapFromDio().toMessage();

  @override
  Stream<LoadingWithTag> _mapToIsLoadingState() => loadingWithTagState;

  @override
  Stream<int> _mapToCountState() => countState
      .setResultStateHandler(this)
      .whereSuccess()
      .map((event) => event.value)
      .shareReplay(maxSize: 1);
}
