// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:test_app/base/common_use_cases/logout_use_case.dart';
import 'package:test_app/base/repositories/auth_repository.dart';

/// Interceptors are a simple way to intercept and modify http requests globally
/// before they are sent to the server. That allows us to configure
/// authentication tokens, add logs of the requests,
/// add custom headers and much more.
/// Interceptors can perform a variety of implicit tasks, from authentication
/// to logging, for every HTTP request/response. Without interception, we will
/// have to implement these tasks explicitly for each HttpClient method call.
/// The AuthInterceptor will inject a Token in headers.
/// This will allow us to remain logged in on the server side or check
/// if the token exists and allow further REST api calls.
/// Here is an example of AuthInterceptor. You have to implement
/// your own logic, regarding needs of your application.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(
      this._authRepository,
      this._logoutUseCase,
      );

  final LogoutUseCase _logoutUseCase;
  final AuthRepository _authRepository;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await getToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final newToken = await loadNewToken();
      if (newToken == null) {
        await _logoutUseCase.execute();
      }
    }
    super.onError(err, handler);
  }

  Future<String?> loadNewToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      return null;
    }
    final newToken = await _authRepository.fetchNewToken();
    return newToken;
  }

  Future<String?> getToken() async => _authRepository.getToken();

  Future<String?> getRefreshToken() async => _authRepository.getRefreshToken();
}
