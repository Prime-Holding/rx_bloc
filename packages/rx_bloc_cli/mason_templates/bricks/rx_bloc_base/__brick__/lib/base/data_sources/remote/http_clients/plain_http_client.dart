import 'package:dio/dio.dart';
import 'package:dio/io.dart';
{{#analytics}}
import '../interceptors/analytics_interceptor.dart';{{/analytics}}
import '../interceptors/log_interceptor.dart';

/// An HTTP client with a minimal set of interceptors.
/// Used for accessing external resources and/or unprotected APIs.
class PlainHttpClient with DioMixin implements Dio {
  PlainHttpClient() {
    options = BaseOptions();
    httpClientAdapter = IOHttpClientAdapter();
    {{#enable_dev_menu}}
    (httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
      if (PlainHttpClient.proxy.isNotEmpty) {
        client.findProxy = ((uri) {
          return 'PROXY ${PlainHttpClient.proxy}:8888';
        });
      }
      if (proxy.isNotEmpty) {
        client.badCertificateCallback = ((cert, host, port) => true);
      }
      return client;
    };{{/enable_dev_menu}}
  }
  {{#enable_dev_menu}}

  static String proxy = '';
  {{/enable_dev_menu}}

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
