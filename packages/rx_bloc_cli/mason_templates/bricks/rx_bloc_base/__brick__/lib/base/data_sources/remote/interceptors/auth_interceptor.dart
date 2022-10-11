{{> licence.dart }}

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import '../../../common_use_cases/fetch_access_token_use_case.dart';
import '../../../common_use_cases/logout_use_case.dart';

/// Interceptors are a simple way to intercept and modify http requests globally
/// before they are sent to the server. That allows us to configure
/// authentication tokens, add logs of the requests, add custom headers and
/// much more.
/// Interceptors can perform a variety of implicit tasks, from authentication
/// to logging, for every HTTP request/response that is intercepted.
///
/// You should implement one or more methods from the contract.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(
    this._logoutUseCase,
    this._fetchAccessTokenUseCase,
    this._locator,
  );

  final LogoutUseCase _logoutUseCase;
  final FetchAccessTokenUseCase _fetchAccessTokenUseCase;
  final Locator _locator;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _fetchAccessTokenUseCase.execute();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      _logMetaDetails(err);
      final newToken =
          await _fetchAccessTokenUseCase.execute(forceFetchNewToken: true);
      if (newToken == null) {
        await _logoutUseCase.execute();
      } else {
        final client = _locator<Dio>();
        final response = err.response;

        if (response != null) {
          final updatedHeaders = Map.of(response.requestOptions.headers);
          updatedHeaders['Authorization'] = 'Bearer $newToken';

          handler.resolve(await client.request(
            err.requestOptions.path,
            cancelToken: err.requestOptions.cancelToken,
            data: err.requestOptions.data,
            onReceiveProgress: err.requestOptions.onReceiveProgress,
            onSendProgress: err.requestOptions.onSendProgress,
            options: Options(
              method: response.requestOptions.method,
              sendTimeout: response.requestOptions.sendTimeout,
              receiveTimeout: response.requestOptions.receiveTimeout,
              extra: response.requestOptions.extra,
              headers: updatedHeaders,
              responseType: response.requestOptions.responseType,
              contentType: response.requestOptions.contentType,
              validateStatus: response.requestOptions.validateStatus,
              receiveDataWhenStatusError:
                  response.requestOptions.receiveDataWhenStatusError,
              followRedirects: response.requestOptions.followRedirects,
              maxRedirects: response.requestOptions.maxRedirects,
              requestEncoder: response.requestOptions.requestEncoder,
              responseDecoder: response.requestOptions.responseDecoder,
              listFormat: response.requestOptions.listFormat,
            ),
            queryParameters: err.requestOptions.queryParameters,
          ));
          return;
        }
      }
    }
    super.onError(err, handler);
  }

  void _logMetaDetails(DioError err) {
    final statusCodeStr =
      err.response?.statusCode != null ? '[${err.response?.statusCode}]' : '';
    final method = err.requestOptions.method;
    final uri = err.requestOptions.uri;

    final requestDetails = '$statusCodeStr [$method] $uri'.trim();
    _logError(requestDetails);
  }

  void _logError(String message) {
    log(message, name: runtimeType.toString());
  }
}
