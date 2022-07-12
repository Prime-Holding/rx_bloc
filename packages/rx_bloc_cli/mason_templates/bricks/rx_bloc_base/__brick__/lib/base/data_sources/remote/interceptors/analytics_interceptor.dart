{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';{{#analytics}}
import 'package:firebase_analytics/firebase_analytics.dart';{{/analytics}}

/// Interceptors are a simple way to intercept and modify http requests globally
/// before they are sent to the server. That allows us to configure
/// authentication tokens, add logs of the requests, add custom headers and
/// much more.
/// Interceptors can perform a variety of implicit tasks, from authentication
/// to logging, for every HTTP request/response that is intercepted.
///
/// You should implement one or more methods from the contract.
class AnalyticsInterceptor extends Interceptor {
  AnalyticsInterceptor( {{#analytics}}this.observer{{/analytics}} );
  {{#analytics}}
  final FirebaseAnalyticsObserver observer;{{/analytics}}

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) { {{#analytics}}
    final hasResponse = err.response != null;
    observer.analytics.logEvent(name: 'RequestError', parameters: {
      'errorType': err.type,
      'errorMessage': err.message,
      'stackTrace': err.stackTrace,
      'requestUrl': err.requestOptions.path,
      'requestMethod': err.requestOptions.method,
      if (hasResponse && err.response!.statusCode != null)
      'responseStatusCode': err.response!.statusCode,
      if (hasResponse && err.response!.data != null)
      'responseData': err.response!.data,
    }); {{/analytics}}
    super.onError(err, handler);
  }
}
