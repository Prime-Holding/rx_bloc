import 'dart:convert';

import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await getToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
  }

  Future<String?> getToken() async => await null;
  Future<String?> getRefreshToken() async => await null;

  Future<String?> saveToken() async => await null;
  Future<String?> saveRefreshToken() async => await null;


  Future<void> loadNewToken()async{}
  Future<void> logout()async{}



  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler)async {
    if(err.response?.statusCode == 401){
      final Map<String, dynamic> errData = jsonDecode(err.response.toString());
      if(errData['details'] != 'Bad credentials'){
        try{
          await loadNewToken();
        }on Exception catch(e){
          await logout();
        }

      }
    }
  }
}
