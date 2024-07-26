import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../base/data_sources/remote/http_clients/api_retry_http_client.dart';
import '../../../../base/extensions/uint8list_extensions.dart';
import '../../../services/ssl_service.dart';

class SSLPinningInterceptor extends QueuedInterceptor {
  SSLPinningInterceptor(
    this.sslService, {
    this.apiRetryHttpClient,
  });

  final SSLService sslService;
  final ApiRetryHttpClient? apiRetryHttpClient;

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    X509Certificate? hostCertificate;
    // open socket to host in order to fetch current SSL fingerprint
    try {
      final socket = await SecureSocket.connect(
        options.uri.host,
        443,
      );
      hostCertificate = socket.peerCertificate;
      await socket.close();
    } catch (error) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          message: error.toString(),
        ),
      );
    }

    final fingerprint = await sslService.getSSLFingerprint();

    // Fetch new fingerprint and retry in case of mismatch
    if (fingerprint != hostCertificate?.der.toSHA256String()) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badCertificate,
          error: hostCertificate,
          message: 'The certificate of the response is not approved.',
        ),
        true,
      );
    }

    super.onRequest(options, handler);
  }

  @override
  Future onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.type == DioExceptionType.badCertificate &&
        apiRetryHttpClient != null) {
      // fetch new SSL fingerprint from the server
      try {
        await sslService.load();
      } on DioException catch (error) {
        return handler.reject(error);
      } catch (error) {
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            message: error.toString(),
          ),
        );
      }

      // retry the initial API call
      try {
        final response = await apiRetryHttpClient!.fetch(err.requestOptions);

        return handler.resolve(response);
      } on DioException catch (error) {
        return super.onError(error, handler);
      }
    }

    super.onError(err, handler);
  }
}
