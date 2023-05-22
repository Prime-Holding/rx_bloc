import 'package:dio/dio.dart';
import 'package:dio/io.dart';{{#enable_dev_menu}}
import '../../../app/config/environment_config.dart';
import '../../local/shared_preferences_instance.dart';{{/enable_dev_menu}}
{{#analytics}}
import '../interceptors/analytics_interceptor.dart';{{/analytics}}
import '../interceptors/log_interceptor.dart';

/// An HTTP client with a minimal set of interceptors.
/// Used for accessing external resources and/or unprotected APIs.
class PlainHttpClient with DioMixin implements Dio {
  PlainHttpClient({{#enable_dev_menu}}this._storage{{/enable_dev_menu}}) {
    options = BaseOptions();
    httpClientAdapter = IOHttpClientAdapter();
    {{#enable_dev_menu}}
    if (EnvironmentConfig.enableDevMenu) {
      setupProxy();
    }{{/enable_dev_menu}}
  }
  {{#enable_dev_menu}}

  final SharedPreferencesInstance _storage;
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
{{#enable_dev_menu}}

  Future<void> setupProxy() async {
    String proxy = await _storage.getString('proxy') ?? '';
    (httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
      if (proxy.isNotEmpty) {
        client.findProxy = ((uri) {
          return 'PROXY $proxy:8888';
        });
        client.badCertificateCallback = ((cert, host, port) => true);
      }
      return client;
    };
  }{{/enable_dev_menu}}
}
