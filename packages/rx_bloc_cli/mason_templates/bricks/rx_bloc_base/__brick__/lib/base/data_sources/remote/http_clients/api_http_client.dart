{{#enable_dev_menu}}
import 'package:alice/alice.dart';{{/enable_dev_menu}}
import 'package:dio/io.dart';
import 'package:dio/dio.dart';
{{#analytics}}
import '../interceptors/analytics_interceptor.dart';{{/analytics}}
import '../../../../lib_auth/data_sources/remote/interceptors/auth_interceptor.dart';
import '../interceptors/log_interceptor.dart';

/// An HTTP client for use with the main backed API.
class ApiHttpClient with DioMixin implements Dio {
  ApiHttpClient() {
    options = BaseOptions();
    httpClientAdapter = IOHttpClientAdapter();
  }

  final logInterceptor = createDioEventLogInterceptor('ApiHttpClient');
  late AuthInterceptor authInterceptor;{{#analytics}}
  late AnalyticsInterceptor analyticsInterceptor;{{/analytics}}

  void configureInterceptors(
      AuthInterceptor authInterceptor,{{#analytics}}
      AnalyticsInterceptor analyticsInterceptor,{{/analytics}}{{#enable_dev_menu}}
      Alice alice,{{/enable_dev_menu}}
  ) {
    this.authInterceptor = authInterceptor;{{#analytics}}
    this.analyticsInterceptor = analyticsInterceptor;{{/analytics}}

    interceptors.addAll([
      logInterceptor,
      authInterceptor,{{#analytics}}
      analyticsInterceptor,{{/analytics}}{{#enable_dev_menu}}
      alice.getDioInterceptor(),{{/enable_dev_menu}}
    ]);
  }
}
