import 'dart:async';

import 'package:rxdart/rxdart.dart';

import './bloc/rx_bloc_base.dart';
import './model/result.dart';

extension ResultStream<T> on Stream<Result<T>> {
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

extension AsResultStream<T> on Stream<T> {
  /// Converts the [Stream] to a [Stream] of [Result]
  ///
  /// As soon as the [Stream] is being subscribed it emits [ResultLoading] immediately,
  /// as afterwards emits either [ResultError] or [ResultSuccess]
  Stream<Result<T>> asResultStream() => map((data) => Result<T>.success(data))
      .onErrorReturnWith((error) => Result<T>.error(error))
      .startWith(Result<T>.loading());
}

extension FutureAsResultStream<T> on Future<T> {
  /// Converts the [Future] to a [Stream] of [Result]
  ///
  /// As soon as the [Stream] is being subscribed it emits [ResultLoading] immediately,
  /// as afterwards emits either [ResultError] or [ResultSuccess]
  Stream<Result<T>> asResultStream() => asStream().asResultStream();
}

extension HandleByRxBlocBase<T> on Stream<Result<T>> {
  /// Handle [ResultLoading] states from stream.
  ///
  /// Once the states are being handled they sink to [loadingState].
  /// Converts the stream to broadcast one based on [shareReplay].
  ///
  /// In case you need to handle error states along with the loading state,
  /// use [setResultStateHandler] instead.
  Stream<Result<T>> setLoadingStateHandler(
    RxBlocBase bloc, {
    bool shareReplay = true,
  }) =>
      // ignore: invalid_use_of_protected_member
      bloc.setLoadingStateHandler(this, shareReplay: shareReplay);

  /// Handle [ResultError] states from the stream.
  ///
  /// Once the states are being handled they sink to [errorState].
  /// Converts the stream to broadcast one based on [shareReplay].
  ///
  /// In case you need to register loading states along with the exceptions,
  /// use [setResultStateHandler] instead.
  Stream<Result<T>> setErrorStateHandler(
    RxBlocBase bloc, {
    bool shareReplay = true,
  }) =>
      // ignore: invalid_use_of_protected_member
      bloc.setErrorStateHandler(this, shareReplay: shareReplay);

  /// Handle [ResultLoading] and [ResultError] by a BLoC.
  ///
  /// Converts the stream to broadcast one based on [shareReplay].
  ///
  /// Useful when multiple type of result streams are executed by a single Bloc,
  /// as all [ResultError] and [ResultLoading] states resides in a central place.
  ///
  /// Once [ResultLoading] states are being handled they sink to [RxBlocBase.loadingState].
  /// Once [ResultError] states are being handled they sink to [RxBlocBase.errorState].
  Stream<Result<T>> setResultStateHandler(RxBlocBase bloc,
          {bool shareReplay = true}) =>
      // ignore: invalid_use_of_protected_member
      bloc.setResultStateHandler(this, shareReplay: shareReplay);
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
