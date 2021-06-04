// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';

import 'package:dio/dio.dart';

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
    // TODO: Add your logic here
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final Map<String, dynamic> errData = jsonDecode(err.response.toString());
      if (errData['details'] != 'Bad credentials') {
        try {
          await loadNewToken();
        } on Exception catch (e) {
          print(e.toString());
          await logout();
        }
      }
    }
    super.onError(err, handler);
  }

  Future<void> loadNewToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      //  Add your logic here
    }
    try {
      final token = await fetchToken();
      await saveToken(token!);
    } catch (e) {
      //  Add your logic here
    }
  }

  // TODO Next methods should be implemented regarding app logic
  Future<String?> getToken() async => Future.value('token');

  Future<String?> fetchToken() async => Future.value('token');

  Future<String?> getRefreshToken() async => Future.value('refreshToken');

  Future<void> saveToken(String token) async {}

  Future<void> saveRefreshToken(String refreshToken) async {}

  Future<void> logout() async {
    //  TODO implement logout functionality
  }
}
