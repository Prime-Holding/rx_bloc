import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../common_blocs/coordinator_bloc.dart';
import '../../models/errors/error_model.dart';

part 'dio_error_mapper.dart';

typedef Callback<E> = Future<E> Function();
typedef SyncCallback<E> = E Function();

abstract class ErrorMapperInterface {
  Stream<E> executeStream<E>(Stream<E> stream, {bool? skipLogs});

  Future<E> execute<E>(Callback<E> callback);

  E executeSync<E>(SyncCallback<E> callback);

  void logError({
    required Object errorObj,
    StackTrace? stackTrace,
  });
}

class ErrorMapper implements ErrorMapperInterface {
  ErrorMapper(this._coordinator);

  final CoordinatorBlocType _coordinator;

  /// Map the potential Future exceptions to Business Models such as:
  /// - ErrorNetworkModel
  /// - ErrorAccessDeniedModel
  /// - ErrorNotFoundModel
  ///
  @override
  Future<E> execute<E>(Callback<E> callback, {bool? skipLogs}) async {
    try {
      return await callback();
    } catch (e, s) {
      if (skipLogs == null || !skipLogs) {
        logError(
          errorObj: e,
          stackTrace: s,
        );
      }

      // Error objects are thrown in the case of a program failure.
      // An `Error` object represents a program failure that the programmer
      // should have avoided.
      // These are not errors that a caller should expect or catch -
      // if they occur, the program is erroneous, and terminating the program
      // may be the safest response.
      if (e is Error) {
        rethrow;
      }

      throw _mapToBusinessModel(e);
    }
  }

  /// Map the potential Future exceptions to Business Models such as:
  /// - ErrorNetworkModel
  /// - ErrorAccessDeniedModel
  /// - ErrorNotFoundModel
  ///
  @override
  Stream<E> executeStream<E>(Stream<E> stream, {bool? skipLogs}) =>
      stream.handleError((error, stackTrace) {
        if (skipLogs == null || !skipLogs) {
          logError(
            errorObj: error,
            stackTrace: stackTrace,
          );
        }

        if (error is Error) {
          throw error;
        }

        throw _mapToBusinessModel(error);
      });

  /// Map the potential Future exceptions to Business Models such as:
  /// - ErrorNetworkModel
  /// - ErrorAccessDeniedModel
  /// - ErrorNotFoundModel
  ///
  @override
  E executeSync<E>(SyncCallback<E> callback, {bool? skipLogs}) {
    try {
      return callback();
    } catch (e, s) {
      if (skipLogs == null || !skipLogs) {
        logError(
          errorObj: e,
          stackTrace: s,
        );
      }

      // Error objects are thrown in the case of a program failure.
      // An `Error` object represents a program failure that the programmer
      // should have avoided.
      // These are not errors that a caller should expect or catch -
      // if they occur, the program is erroneous, and terminating the program
      // may be the safest response.
      if (e is Error) {
        rethrow;
      }

      throw _mapToBusinessModel(e);
    }
  }

  @override
  void logError({required Object errorObj, StackTrace? stackTrace}) {
    if (errorObj is ErrorModel) {
      log('Business Error', error: errorObj, stackTrace: stackTrace);

      _coordinator.events.errorLogged(
        error: errorObj,
        stackTrace: stackTrace?.toString() ?? '',
      );
    }

    if (errorObj is Exception) {
      log('Exception', error: errorObj, stackTrace: stackTrace);
      _coordinator.events.errorLogged(
        error: _mapExceptionToBusinessError(errorObj),
        stackTrace: stackTrace?.toString() ?? '',
      );
    }
  }

  Object _mapToBusinessModel(Object object) {
    if (object is ErrorModel) {
      return object;
    }

    if (object is Exception) {
      return _mapExceptionToBusinessError(object);
    }

    return object;
  }

  /// Map the passed [exception] to a Business Error.
  ErrorModel _mapExceptionToBusinessError(Exception exception) {
    if (exception is DioError) {
      return exception.asErrorModel();
    }

    // Use custom error mappers here.

    return UnknownErrorModel(exception: exception);
  }
}
