import 'package:dio/dio.dart';

import '../interceptors/log_interceptor.dart';

/// An HTTP client with a minimal set of interceptors.
/// Used for accessing external resources and/or unprotected APIs.
class PlainHttpClient with DioMixin implements Dio {
  PlainHttpClient() {
    options = BaseOptions();
    httpClientAdapter = HttpClientAdapter();
  }

  final logInterceptor = createDioEventLogInterceptor('PlainHttpClient');

  void configureInterceptors() {
    interceptors.addAll([
      logInterceptor,
    ]);
  }
}
