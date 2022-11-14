import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../common_blocs/coordinator_bloc.dart';
// import '../extensions/error_model_extensions.dart';
import '../../models/error/error_model.dart';

part 'dio_error_mapper.dart';
part 'platform_error_mapper.dart';
part 'state_error_mapper.dart';

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
  ErrorMapper(this._locator);

  final Locator _locator;

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
      throw _mapToBusinessModel(e);
    }
  }

  @override
  void logError({required Object errorObj, StackTrace? stackTrace}) {
    final coordinator = _locator<CoordinatorBlocType>();
    if (errorObj is ErrorModel) {
      log('Business Error', error: errorObj, stackTrace: stackTrace);

      coordinator.events.errorLogged(
        error: errorObj,
        stackTrace: stackTrace?.toString() ?? '',
      );
    }

    if (errorObj is Exception) {
      log('Exception', error: errorObj, stackTrace: stackTrace);
      coordinator.events.errorLogged(
        error: _mapExceptionToBusinessError(errorObj),
        stackTrace: stackTrace?.toString() ?? '',
      );
    }

    if (errorObj is Error) {
      log('Error', error: errorObj, stackTrace: errorObj.stackTrace);
      coordinator.events.errorLogged(
        error: _mapErrorToBusinessError(errorObj),
        stackTrace: stackTrace?.toString() ?? '',
      );
    }
  }

  Object _mapToBusinessModel(Object obj) {
    if (obj is ErrorModel) {
      return obj;
    }

    if (obj is Exception) {
      return _mapExceptionToBusinessError(obj);
    }

    if (obj is Error) {
      return _mapErrorToBusinessError(obj);
    }

    return obj;
  }

  /// Map the passed [error] to a Business Error.
  ErrorModel _mapErrorToBusinessError(Error error) {
    if (error is StateError) {
      return error.asErrorModel();
    }

    return ErrorUnknown(error: error);
  }

  /// Map the passed [exception] to a Business Error.
  ErrorModel _mapExceptionToBusinessError(Exception exception) {
    if (exception is DioError) {
      return exception.asErrorModel();
    }

    if (exception is PlatformException) {
      return exception.asErrorModel();
    }

    return ErrorUnknown(exception: exception);
  }
}
