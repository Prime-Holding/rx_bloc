import 'package:dio/io.dart';
import 'package:dio/dio.dart';
{{#analytics}}
import '../interceptors/analytics_interceptor.dart';{{/analytics}}
import '../interceptors/log_interceptor.dart';

/// An HTTP client with a minimal set of interceptors.
/// Used for accessing external resources and/or unprotected APIs.
class PlainHttpClient with DioMixin implements Dio {
  PlainHttpClient() {
    options = BaseOptions();
    httpClientAdapter = IOHttpClientAdapter();
  }

  final logInterceptor = createDioEventLogInterceptor('PlainHttpClient');{{#analytics}}
  late AnalyticsInterceptor analyticsInterceptor;{{/analytics}}

  void configureInterceptors({{#analytics}}
      AnalyticsInterceptor analyticsInterceptor,{{/analytics}}
  ) { {{#analytics}}
    this.analyticsInterceptor = analyticsInterceptor;{{/analytics}}

    interceptors.addAll([
      logInterceptor,{{#analytics}}
      analyticsInterceptor,{{/analytics}}
    ]);
  }
}
