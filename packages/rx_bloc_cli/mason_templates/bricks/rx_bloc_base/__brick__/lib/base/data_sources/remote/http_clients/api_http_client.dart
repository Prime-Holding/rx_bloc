import 'package:dio/dio.dart';
import 'package:dio/io.dart';
{{#has_authentication}}
import '../../../../lib_auth/data_sources/remote/interceptors/auth_interceptor.dart';{{/has_authentication}}{{#enable_dev_menu}}
import '../../../../lib_dev_menu/extensions/setup_proxy.dart';
import '../../../app/config/environment_config.dart';{{/enable_dev_menu}}{{#analytics}}
import '../interceptors/analytics_interceptor.dart';{{/analytics}}
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

  final logInterceptor = createDioEventLogInterceptor('ApiHttpClient');{{#has_authentication}}
  late AuthInterceptor authInterceptor;{{/has_authentication}}{{#analytics}}
  late AnalyticsInterceptor analyticsInterceptor;{{/analytics}}

  void configureInterceptors( {{#has_authentication}}
      AuthInterceptor authInterceptor,{{/has_authentication}}{{#analytics}}
      AnalyticsInterceptor analyticsInterceptor,{{/analytics}}
  ) { {{#has_authentication}}
    this.authInterceptor = authInterceptor;{{/has_authentication}}{{#analytics}}
    this.analyticsInterceptor = analyticsInterceptor;{{/analytics}}

    interceptors.addAll([
      logInterceptor,{{#has_authentication}}
      authInterceptor,{{/has_authentication}}{{#analytics}}
      analyticsInterceptor,{{/analytics}}
    ]);
  }
}
