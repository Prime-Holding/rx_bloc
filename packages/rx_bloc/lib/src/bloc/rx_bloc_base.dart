import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../extensions.dart';
import '../model/result.dart';
import 'loading_bloc.dart';

// ignore: public_member_api_docs
abstract class RxBlocTypeBase {
  /// Dispose all StreamControllers and Composite Subscriptions
  void dispose();
}

/// A base class that handles all common BloC functionality such as
/// 1. Loading State
/// 2. Error State
abstract class RxBlocBase {
  /// A loading bloc that holds the loading state of all handled result streams.
  ///
  /// To register a result stream either call:
  ///
  /// ```dart
  /// setLoadingStateHandler(resultStream);
  /// ```
  ///
  /// or:
  ///
  /// ```dart
  ///  setResultStateHandler(resultStream);
  /// ```
  ///
  /// To get the stream of all loading states simply call:
  /// ```
  /// _loadingBloc.isLoading
  /// ```
  ///
  final LoadingBloc _loadingBloc = LoadingBloc();

  /// The loading states of all handled result streams.
  @protected
  Stream<bool> get loadingState => _loadingBloc.isLoading;

  /// The errors of all handled result streams.
  @protected
  Stream<Exception> get errorState => _resultStreamExceptionsSubject;

  final _resultStreamExceptionsSubject = BehaviorSubject<Exception>();

  final _compositeSubscription = CompositeSubscription();

  /// Handle [ResultError] states from the stream.
  ///
  /// Once the states are being handled they sink to [errorState].
  /// Converts the stream to broadcast one based on [shareReplay].
  ///
  /// In case you need to register loading states along with the exceptions,
  /// use [setResultStateHandler] instead.
  @protected
  Stream<Result<T>> setErrorStateHandler<T>(
    Stream<Result<T>> resultStream, {
    bool shareReplay = true,
  }) {
    resultStream
        .asSharedStream(shareReplay: shareReplay)
        .whereError()
        .bind(_resultStreamExceptionsSubject)
        .disposedBy(_compositeSubscription);

    return resultStream;
  }

  /// Handle [ResultLoading] states from stream.
  ///
  /// Once the states are being handled they sink to [loadingState].
  /// Converts the stream to broadcast one based on [shareReplay].
  ///
  /// In case you need to handle error states along with the loading state,
  /// use [setResultStateHandler] instead.
  @protected
  Stream<Result<T>> setLoadingStateHandler<T>(
    Stream<Result<T>> resultStream, {
    bool shareReplay = true,
  }) {
    resultStream = resultStream.asSharedStream(shareReplay: shareReplay);

    _loadingBloc.addStream(resultStream.isLoading());
    return resultStream;
  }

  /// Handle [ResultLoading] and [ResultError] states from the stream.
  ///
  /// Converts the stream to broadcast one based on [shareReplay].
  ///
  /// Useful when multiple type of result streams are executed by a single Bloc,
  /// as all [ResultError] and [ResultLoading] states resides in a central place
  ///
  /// Once [ResultLoading] states are being handled they sink to [loadingState].
  /// Once [ResultError] states are being handled they sink to [errorState].
  @protected
  Stream<Result<T>> setResultStateHandler<T>(
    Stream<Result<T>> resultStream, {
    bool shareReplay = true,
  }) {
    resultStream = resultStream.asSharedStream(shareReplay: shareReplay);

    setErrorStateHandler(resultStream, shareReplay: false);
    setLoadingStateHandler(resultStream, shareReplay: false);
    return resultStream;
  }

  /// Disposes all internally created streams
  void dispose() {
    _resultStreamExceptionsSubject.close();
    _compositeSubscription.dispose();
    _loadingBloc.dispose();
  }
}

extension _StreamAsSharedStream<T> on Stream<T> {
  Stream<T> asSharedStream({bool shareReplay = true}) {
    if (shareReplay) {
      if (this is! ReplayStream<T>) {
        return this.shareReplay(maxSize: 1);
      }
    } else if (this is! PublishSubject<T>) {
      return share();
    }

    return this;
  }
}
