import 'package:dio/dio.dart';
import 'package:dio/io.dart';

{{#enable_dev_menu}}
import '../../../../lib_dev_menu/extensions/setup_proxy.dart';
import '../../../app/config/environment_config.dart';{{/enable_dev_menu}}{{#analytics}}
import '../interceptors/analytics_interceptor.dart';{{/analytics}}
import '../interceptors/log_interceptor.dart';

/// An HTTP client with a minimal set of interceptors.
/// Used for accessing external resources and/or unprotected APIs.
class PlainHttpClient with DioMixin implements Dio {
  PlainHttpClient() {
    options = BaseOptions();
    httpClientAdapter = IOHttpClientAdapter();
    {{#enable_dev_menu}}
    if (EnvironmentConfig.enableDevMenu) {
      httpClientAdapter.setupProxy();
    }{{/enable_dev_menu}}
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
