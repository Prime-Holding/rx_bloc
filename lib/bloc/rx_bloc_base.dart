import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../extensions.dart';
import '../model/result.dart';
import 'loading_bloc.dart';

abstract class RxBlocTypeBase {
  void dispose();
}

abstract class RxBlocBase {
  /// A loading bloc that holds all registered requests.
  ///
  /// To register a request either call:
  ///
  /// ```
  /// registerRequestToLoading(request);
  /// ```
  ///
  /// or:
  ///
  /// ```
  ///  registerRequest(request);
  /// ```
  ///
  /// To get the stream of all loading states simply call:
  /// ```
  /// loadingBloc.isLoading
  /// ```
  ///
  @protected
  final LoadingBloc _loadingBloc = LoadingBloc();

  /// The loading states of all registered requests.
  Stream<bool> get requestsLoadingState => _loadingBloc.isLoading;

  /// The exceptions of all registered requests.
  Stream<Exception> get requestsExceptions => _requestExceptionsSubject;

  final _requestExceptionsSubject = BehaviorSubject<Exception>();

  final _compositeSubscription = CompositeSubscription();

  /// Registers a request to the error container.
  ///
  /// In case you need to register loading states along with the exceptions,
  /// use [registerRequest] instead.
  StreamSubscription<Exception> registerRequestToErrors<T>(
          Stream<Result<T>> request) =>
      request
          .whereError()
          .bind(_requestExceptionsSubject)
          .disposedBy(_compositeSubscription);

  /// Registers a request to the loading container.
  ///
  /// In case you need to register exceptions along with the loading state,
  /// use [registerRequest] instead.
  Stream<Result<T>> registerRequestToLoading<T>(Stream<Result<T>> request) =>
      _loadingBloc.addStream(request.isLoading());

  /// Registers [ResultLoading] and [ResultError] to a central container.
  ///
  /// Useful when multiple type of requests are executed by a single Bloc,
  /// as all [ResultError] and [ResultLoading] states resides in a central place.
  ///
  /// Once a requests is being registered it sinks into those properties:
  /// ```
  /// [requestsExceptions] and [requestsLoadingState]
  /// ```
  @protected
  Stream<Result<T>> registerRequest<T>(Stream<Result<T>> request) {
    registerRequestToErrors(request);
    registerRequestToLoading(request);
    return request;
  }

  /// Disposes all internally created streams
  dispose() {
    _requestExceptionsSubject.close();
    _compositeSubscription.dispose();
    _loadingBloc.dispose();
  }
}
