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
  /// Registers [ResultLoading] and [ResultError] to a BloC.
  ///
  /// Useful when multiple type of requests are executed by a single Bloc,
  /// as all [ResultError] and [ResultLoading] states resides in a central place.
  ///
  /// Once a requests is being registered it sinks into those properties:
  /// [RxBlocBase.requestsExceptions] and [RxBlocBase.requestsLoadingState]
  Stream<Result<T>> registerRequest(RxBlocBase bloc) =>
      // ignore: invalid_use_of_protected_member
      bloc.registerRequest(this);
}

extension Bind<T> on Stream<T> {
  /// Bind a stream to the given subject [subject].
  ///
  /// Each event from the stream will be added to the subject, meaning that the
  /// both needs to be of the same type.
  /// Be aware that the binding is facilitating the subscribing, so the
  /// unsubscribing needs to be handled accordingly either by
  /// using [CompositeSubscription] or manually.
  StreamSubscription<T> bind(BehaviorSubject<T> subject) =>
      listen((data) => subject.value = data);
}

extension Dispose<T> on StreamSubscription<T> {
  /// Add the stream to [compositeSubscription].
  ///
  /// Once [compositeSubscription] is being disposed all added subscriptions
  /// will be disposed automatically
  StreamSubscription<T> disposedBy(
          CompositeSubscription compositeSubscription) =>
      compositeSubscription.add(this);
}
