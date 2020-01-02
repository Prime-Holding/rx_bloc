import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../extensions.dart';
import '../model/result.dart';
import 'loading_bloc.dart';

abstract class RxBlocBase {
  @protected
  final LoadingBloc loadingBloc = LoadingBloc();

  Stream<ResultError> get requestExceptions => _requestExceptionsSubject;

  final _requestExceptionsSubject = BehaviorSubject<ResultError>();

  final _compositeSubscription = CompositeSubscription();

  @protected
  Stream<Result<T>> registerRequest<T>(Stream<Result<T>> request) {
    loadingBloc.addStream(request.isLoading());

    request
        .whereError()
        .bind(_requestExceptionsSubject)
        .disposedBy(_compositeSubscription);

    return request;
  }

  dispose() {
    _requestExceptionsSubject.close();
    _compositeSubscription.dispose();
    loadingBloc.dispose();
  }
}
