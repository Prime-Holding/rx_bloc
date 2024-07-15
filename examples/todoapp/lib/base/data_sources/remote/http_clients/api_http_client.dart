import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../../../../lib_dev_menu/extensions/setup_proxy.dart';
import '../../../app/config/environment_config.dart';
import '../interceptors/log_interceptor.dart';

/// An HTTP client for use with the main backed API.
class ApiHttpClient with DioMixin implements Dio {
  ApiHttpClient() {
    options = BaseOptions();
    httpClientAdapter = IOHttpClientAdapter();

    if (EnvironmentConfig.enableDevMenu) {
      httpClientAdapter.setupProxy();
    }
  }

  final logInterceptor = createDioEventLogInterceptor('ApiHttpClient');

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
