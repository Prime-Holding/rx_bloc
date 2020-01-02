import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'bloc/rx_bloc_base.dart';
import 'model/result.dart';

extension StreamResult<T> on Stream<Result<T>> {
  Stream<T> whereSuccess() =>
      whereType<ResultSuccess<T>>().map((data) => data.data);

  Stream<ResultError> whereError() => whereType<ResultError<T>>();

  Stream<bool> isLoading() => map((data) => data.isLoading);
}

extension AsResultStream<T> on Future<T> {
  Stream<Result<T>> asResultStream() => asStream()
      .map((data) => Result.success(data))
      .onErrorReturnWith((error) => Result.error(error))
      .startWith(Result.loading());
}

extension RegisterInRxBlocBase<T> on Stream<Result<T>> {
  Stream<Result<T>> registerRequest(RxBlocBase viewModel) =>
      // ignore: invalid_use_of_protected_member
      viewModel.registerRequest(this);
}

extension Bind<T> on Stream<T> {
  StreamSubscription<T> bind(BehaviorSubject<T> subject) =>
      listen((data) => subject.value = data);
}

extension Dispose<T> on StreamSubscription<T> {
  StreamSubscription<T> disposedBy(CompositeSubscription compositeSubscription) =>
      compositeSubscription.add(this);
}
