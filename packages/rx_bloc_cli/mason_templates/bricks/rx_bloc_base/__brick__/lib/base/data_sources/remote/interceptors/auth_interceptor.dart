{{> licence.dart }}

import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../common_use_cases/fetch_access_token_use_case.dart';
import '../../../common_use_cases/logout_use_case.dart';
import '../http_clients/api_http_client.dart';

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(
    this.apiHttpClient,
    this.fetchAccessTokenUseCase,
    this.logoutUseCase,
  );

  final ApiHttpClient apiHttpClient;
  final FetchAccessTokenUseCase fetchAccessTokenUseCase;
  final LogoutUseCase logoutUseCase;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await fetchAccessTokenUseCase.execute();

    // NOTE: Here you can check if the current token is expired or about to
    // expire. In this case fetch a new token using `await` which will block
    // the request queue until the token has been refreshed.
    // try {
    //   // get new token using
    //   // _log('Access token expired. Fetching a new one.');
    //   // _fetchAccessTokenUseCase.execute(forceFetchNewToken: true);
    // } on DioError catch (error) {
    //   return handler.reject(error);
    // } catch (error) {
    //   return handler.reject(DioError(requestOptions: options));
    // }

    if (accessToken != null) {
      final headers = Map.of(options.headers);
      headers['Authorization'] = 'Bearer $accessToken';
      final updatedOptions = options.copyWith(headers: headers);
      return handler.next(updatedOptions);
    }

    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    final currentAccessToken = await fetchAccessTokenUseCase.execute();

    // Assuming status code 401 stands for token expired.
    if (err.response?.statusCode == 401) {
      var options = err.response!.requestOptions;

      // If the token has been updated, repeat the request.
      if (options.headers['Authorization'] != 'Bearer $currentAccessToken') {
        // Schedule a new microtask and immediately exit the
        // interceptor to unblock the queue.
        _log('The access token has been updated. Retry the request.');
        unawaited(apiHttpClient.fetch(options).then(
              (r) => handler.resolve(r),
              onError: (e) => handler.reject(e),
            ));
        return;
      }

      String? newToken;

      try {
        _log('Fetching a new access token.');
        newToken =
            await fetchAccessTokenUseCase.execute(forceFetchNewToken: true);
      } on DioError catch (error) {
        handler.reject(error);
      } catch (error) {
        handler.reject(DioError(requestOptions: options));
      }

      if (newToken == null) {
        _log('Could not fetch new access token. Logging out.');
        unawaited(logoutUseCase.execute());
        return;
      }

      // Schedule a new microtask and immediately exit the
      // interceptor to unblock the queue.
      _log('Retrying the request with the new access token.');
      unawaited(apiHttpClient.fetch(options).then(
            (r) => handler.resolve(r),
            onError: (e) => handler.reject(e),
          ));
      return;
    }

    super.onError(err, handler);
  }

  void _log(String message) {
    log(message, name: runtimeType.toString());
  }
}
