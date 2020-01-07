import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'bloc/rx_bloc_base.dart';
import 'model/result.dart';

extension StreamResult<T> on Stream<Result<T>> {
  /// Finds the [ResultSuccess] as unwraps the [ResultSuccess.data] from it.
  ///
  /// It filters the other types of [Result] such as [ResultError] and [ResultLoading].
  Stream<T> whereSuccess() =>
      whereType<ResultSuccess<T>>().map((data) => data.data);

  /// Finds the [ResultError] as unwraps the [ResultError.error] from it.
  ///
  /// It filters the other types of [Result] such as [ResultSuccess] and [ResultLoading].
  Stream<Exception> whereError() =>
      whereType<ResultError<T>>().map((error) => error.error);

  /// Returns `true` if the [Result] is [ResultLoading], otherwise returns `false`
  ///
  Stream<bool> isLoading() => map((data) => data is ResultLoading);
}

extension AsResultStream<T> on Future<T> {
  /// Converts the [Future] to a [Stream] of [Result]
  ///
  /// As soon as the [Stream] is being subscribed it emits [ResultLoading] immediately,
  /// as afterwards emits either [ResultError] or [ResultSuccess]
  Stream<Result<T>> asResultStream() => asStream()
      .map((data) => Result.success(data))
      .onErrorReturnWith((error) => Result.error(error))
      .startWith(Result.loading());
}

extension RegisterInRxBlocBase<T> on Stream<Result<T>> {
  ///
  ///
  Stream<Result<T>> registerRequest(RxBlocBase viewModel) =>
      // ignore: invalid_use_of_protected_member
      viewModel.registerRequest(this);
}

extension Bind<T> on Stream<T> {
  StreamSubscription<T> bind(BehaviorSubject<T> subject) =>
      listen((data) => subject.value = data);
}

extension Dispose<T> on StreamSubscription<T> {
  StreamSubscription<T> disposedBy(
          CompositeSubscription compositeSubscription) =>
      compositeSubscription.add(this);
}
