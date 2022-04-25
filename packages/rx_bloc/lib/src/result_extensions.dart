import 'package:rxdart/rxdart.dart';

import '../src/model/result.dart';

extension ResultMapStreamX<E> on Stream<E> {
  /// Map the value of the stream to ResultSuccess<E>
  ///
  /// Example:
  /// ```
  /// ResultSuccess<int> result = Stream.value(10)
  ///   .mapToResult(); // Result.success('10')
  /// ResultSuccess<int> result = Stream.value(10)
  ///   .mapToResult((value) => value * 10); // Result.success('100')
  /// ```
  Stream<Result<E>> mapToResult([E Function(E)? mapper]) => map((data) {
        if (mapper != null) {
          return Result<E>.success(mapper(data));
        }

        return Result<E>.success(data);
      });

  /// Map the current stream to a new [Result] stream,
  /// as combining it with another [stream].
  ///
  /// Use [mapSuccess] to map the current stream with the
  /// given [stream] to a new [Result] stream.
  ///
  /// Example:
  /// ```
  /// Result<String> result = Stream.value(0).withLatestFromResult<String>(
  ///     Stream.value(Result.success('1')),
  ///     (value, resultValue) => '$value, $resultValue', //0, 1
  /// );
  /// ```
  Stream<Result<R>> withLatestFromResult<R>(
    Stream<Result<R>> stream,
    R Function(E, R) mapSuccess,
  ) {
    return withLatestFrom<Result<R>, Result<R>>(
      stream,
      (e, t) => t.mapResult((data) => mapSuccess(e, data)),
    );
  }
}

extension ResultMapStream<E> on Stream<Result<E>> {
  /// Map the current [Result] stream to a new [Result] one,
  /// which could be from a different type.
  ///
  /// Use the [mapSuccess] to map the success from the current stream to the
  /// result stream.
  /// Example:
  /// ```
  /// Result<String> result = Stream.value(Result.success(10))
  ///   .mapResult((value) => value * 10)
  ///   .mapResult((value) => value.toString()); // Result.success('100')
  /// ```
  Stream<Result<T>> mapResult<T>(T Function(E) mapSuccess) => map(
        (result) => result.mapResult(mapSuccess),
      );

  /// Map the current [Result] stream to a new [Result] one,
  /// which could be from a different type.
  ///
  /// Use the [mapSuccess] callback to map the success from the current stream
  /// to the result stream in an async manner.
  ///
  /// Example:
  /// ```
  /// Result<String> result = Stream.value(Result.success(10))
  ///   .asyncMapResult((value) async => value * 10)
  ///   .asyncMapResult((value) async => value.toString()); // Result.success('100')
  /// ```
  Stream<Result<T>> asyncMapResult<T>(Future<T> Function(E) mapSuccess) =>
      asyncMap(
        (result) => result.asyncMapResult(mapSuccess),
      );
}

extension ResultMap<E> on Result<E> {
  /// Map the current [Result] to a new [Result] one,
  /// which could be from a different type.
  Future<Result<T>> asyncMapResult<T>(Future<T> Function(E) mapSuccess) async {
    final that = this;

    if (that is ResultSuccess<E>) {
      return Result<T>.success(await mapSuccess(that.data));
    }

    return _mapResultToErrorOrLoading<T>();
  }

  /// Map the current [Result] to a new [Result] one,
  /// which could be from a different type.
  Result<T> mapResult<T>(T Function(E) mapSuccess) {
    final that = this;

    if (that is ResultSuccess<E>) {
      return Result<T>.success(mapSuccess(that.data));
    }

    return _mapResultToErrorOrLoading<T>();
  }

  Result<T> _mapResultToErrorOrLoading<T>() {
    final that = this;

    if (that is ResultError<E>) {
      return Result<T>.error(that.error);
    }

    return Result<T>.loading();
  }
}
