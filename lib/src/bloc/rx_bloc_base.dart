import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../extensions.dart';
import '../model/result.dart';
import 'loading_bloc.dart';

abstract class RxBlocTypeBase {
  void dispose();
}

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
  /// Converts the stream to broadcast one based on [shareStream].
  ///
  /// In case you need to register loading states along with the exceptions,
  /// use [setResultStateHandler] instead.
  @protected
  Stream<Result<T>> setErrorStateHandler<T>(
    Stream<Result<T>> resultStream, {
    bool shareStream = true,
  }) {
    resultStream
        .transformAs(shareStream: shareStream)
        .whereError()
        .bind(_resultStreamExceptionsSubject)
        .disposedBy(_compositeSubscription);

    return resultStream;
  }

  /// Handle [ResultLoading] states from stream.
  ///
  /// Once the states are being handled they sink to [loadingState].
  /// Converts the stream to broadcast one based on [shareStream].
  ///
  /// In case you need to handle error states along with the loading state,
  /// use [setResultStateHandler] instead.
  @protected
  Stream<Result<T>> setLoadingStateHandler<T>(
    Stream<Result<T>> resultStream, {
    bool shareStream = true,
  }) {
    resultStream = resultStream.transformAs(shareStream: shareStream);

    _loadingBloc.addStream(resultStream.isLoading());
    return resultStream;
  }

  /// Handle [ResultLoading] and [ResultError] states from the stream.
  ///
  /// Converts the stream to broadcast one based on [shareStream].
  ///
  /// Useful when multiple type of result streams are executed by a single Bloc,
  /// as all [ResultError] and [ResultLoading] states resides in a central place.
  ///
  /// Once [ResultLoading] states are being handled they sink to [loadingState].
  /// Once [ResultError] states are being handled they sink to [errorState].
  @protected
  Stream<Result<T>> setResultStateHandler<T>(
    Stream<Result<T>> resultStream, {
    bool shareStream = true,
  }) {
    resultStream = resultStream.transformAs(shareStream: shareStream);

    setErrorStateHandler(resultStream, shareStream: false);
    setLoadingStateHandler(resultStream, shareStream: false);
    return resultStream;
  }

  /// Disposes all internally created streams
  dispose() {
    _resultStreamExceptionsSubject.close();
    _compositeSubscription.dispose();
    _loadingBloc.dispose();
  }
}

extension _StreamAsShareReplayed<T> on Stream<T> {
  Stream<T> transformAs({bool shareStream = true}) {
    if (shareStream && this is! Subject<Result<T>>) {
      return this.share();
    } else if (!shareStream) {
      return this.shareReplay(maxSize: 1);
    }

    return this;
  }
}
