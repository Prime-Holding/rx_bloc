import 'package:dio/dio.dart';
import 'package:dio/io.dart';{{#enable_dev_menu}}
import '../../../app/config/environment_config.dart';
import '../../../../lib_dev_menu/extensions/setup_proxy.dart';{{/enable_dev_menu}}
{{#analytics}}
import '../interceptors/analytics_interceptor.dart';{{/analytics}}
import '../../../../lib_auth/data_sources/remote/interceptors/auth_interceptor.dart';
import '../interceptors/log_interceptor.dart';

/// An HTTP client for use with the main backed API.
class ApiHttpClient with DioMixin implements Dio {
  ApiHttpClient() {
    options = BaseOptions();
    httpClientAdapter = IOHttpClientAdapter();
    {{#enable_dev_menu}}
    if (EnvironmentConfig.enableDevMenu) {
      httpClientAdapter.setupProxy();
    }
   {{/enable_dev_menu}}
  }

  final logInterceptor = createDioEventLogInterceptor('ApiHttpClient');
  late AuthInterceptor authInterceptor;{{#analytics}}
  late AnalyticsInterceptor analyticsInterceptor;{{/analytics}}

  void configureInterceptors(
      AuthInterceptor authInterceptor,{{#analytics}}
      AnalyticsInterceptor analyticsInterceptor,{{/analytics}}
  ) {
    this.authInterceptor = authInterceptor;{{#analytics}}
    this.analyticsInterceptor = analyticsInterceptor;{{/analytics}}

    interceptors.addAll([
      logInterceptor,
      authInterceptor,{{#analytics}}
      analyticsInterceptor,{{/analytics}}
    ]);
  }
}
