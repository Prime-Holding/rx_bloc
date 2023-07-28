import 'package:dio/dio.dart';

import '../interceptors/log_interceptor.dart';

/// An HTTP client for use with the main backed API.
class ApiHttpClient with DioMixin implements Dio {
  ApiHttpClient() {
    options = BaseOptions();
    httpClientAdapter = HttpClientAdapter();
  }

  final logInterceptor = createDioEventLogInterceptor('ApiHttpClient');

  void configureInterceptors() {
    interceptors.addAll([
      logInterceptor,
    ]);
  }
}
