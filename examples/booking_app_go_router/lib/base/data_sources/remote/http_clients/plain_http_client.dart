import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import '../interceptors/log_interceptor.dart';

/// An HTTP client with a minimal set of interceptors.
/// Used for accessing external resources and/or unprotected APIs.
class PlainHttpClient with DioMixin implements Dio {
  PlainHttpClient() {
    options = BaseOptions();
    httpClientAdapter = DefaultHttpClientAdapter();
  }

  final logInterceptor = createDioEventLogInterceptor('PlainHttpClient');

  void configureInterceptors(
  ) { 

    interceptors.addAll([
      logInterceptor,
    ]);
  }
}
