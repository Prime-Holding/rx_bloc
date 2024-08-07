import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../../../../lib_dev_menu/extensions/setup_proxy.dart';
import '../../../app/config/environment_config.dart';
import '../interceptors/log_interceptor.dart';

/// An HTTP client with a minimal set of interceptors.
/// Used for accessing external resources and/or unprotected APIs.
class PlainHttpClient with DioMixin implements Dio {
  PlainHttpClient() {
    options = BaseOptions();
    httpClientAdapter = IOHttpClientAdapter();

    if (EnvironmentConfig.enableDevMenu) {
      httpClientAdapter.setupProxy();
    }
  }

  final logInterceptor = createDioEventLogInterceptor('PlainHttpClient');

  void configureInterceptors() {
    interceptors.addAll([
      logInterceptor,
    ]);
  }

  @override
  Future<Response> download(String urlPath, savePath,
      {ProgressCallback? onReceiveProgress,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      bool deleteOnError = true,
      String lengthHeader = Headers.contentLengthHeader,
      Object? data,
      Options? options}) {
    // TODO: implement download
    throw UnimplementedError();
  }
}
