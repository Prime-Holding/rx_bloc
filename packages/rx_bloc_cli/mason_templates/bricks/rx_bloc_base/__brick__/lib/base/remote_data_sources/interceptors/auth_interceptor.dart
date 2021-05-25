import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await getToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
  }

  Future<String?> getToken() async =>  Future.value('token');
  Future<String?> fetchToken() async =>  Future.value('token');
  Future<String?> getRefreshToken() async => Future.value('refreshToken');

  Future<void> saveToken(String token) async { }
  Future<void> saveRefreshToken(String refreshToken) async { }


  Future<void> loadNewToken()async{
    final refreshToken = await getRefreshToken();
    if(refreshToken == null){
      throw Exception('No access');
    }
    try {
      final token = await fetchToken();
      await saveToken(token!);
    }catch (e){
      throw Exception(e);
    }
  }

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
