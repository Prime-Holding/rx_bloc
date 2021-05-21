import 'package:dio/dio.dart';
import 'package:project_name/base/http/interceptors/analytics_interceptor.dart';
import 'package:project_name/base/http/interceptors/auth_interceptor.dart';

class HttpService{
  HttpService(){
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
    ));
    _initializeInterceptors();
  }

  late Dio _dio;
  static const _baseUrl = 'http://primeholding.com/api';

  void _initializeInterceptors(){
    _dio.interceptors
        ..add(AuthInterceptor())
        ..add(AnalyticsInterceptor());
  }



}