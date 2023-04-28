import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../base/data_sources/remote/http_clients/api_http_client.dart';
import '../../lib_auth/data_sources/remote/interceptors/auth_interceptor.dart';

extension DioFactoryX on Dio {
  static String proxy = '';

  static Dio refreshTokenInstance = newInstance();

  static Dio newInstance() {
    final dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      if (DioFactoryX.proxy.isNotEmpty) {
        client.findProxy = ((uri) {
          return 'PROXY ${DioFactoryX.proxy}:8888';
        });
      }
      if (proxy.isNotEmpty) {
        client.badCertificateCallback = ((cert, host, port) => true);
      }
      return client;
    };

    return dio;
  }

  void addInterceptors(
    BuildContext context, {
    auth = true,
    analytics = true,
    rsa = true,
    proCreditHeaders = true,
    language = true,
    mock = true,
    sslPinning = true,
  }) =>
      interceptors.addAll([
        if (auth)
          AuthInterceptor(
            context.read<ApiHttpClient>(),
            context.read(),
            context.read(),
          ),
      ]);
}

// extension DioErrorExtension on DioError {
//   bool isNetworkException() =>
//       error is CertificateCouldNotBeVerifiedException ||
//       error is SocketException ||
//       error is CertificateNotVerifiedException;
// }
