{{> licence.dart }}

import 'package:dio/dio.dart';{{#analytics}}
import 'package:firebase_analytics/firebase_analytics.dart';{{/analytics}}

/// Interceptors are a simple way to intercept and modify http requests globally
/// before they are sent to the server. That allows us to configure
/// authentication tokens, add logs of the requests,
/// add custom headers and much more.
/// Interceptors can perform a variety of implicit tasks, from authentication
/// to logging, for every HTTP request/response. Without interception, we will
/// have to implement these tasks explicitly for each HttpClient method call.
/// We use analytics interceptor to push notifications, present adds
/// and collect data for users behaviour.
/// You should implement one or more methods from the contract.
class AnalyticsInterceptor extends Interceptor {
  AnalyticsInterceptor( {{#analytics}}this.observer{{/analytics}} );
  {{#analytics}}
  final FirebaseAnalyticsObserver observer;{{/analytics}}

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) { {{#analytics}}
    observer.analytics.logEvent(name: 'dioError', parameters: {
      'errorType': err.type,
      'errorMessage': err.message,
      'stackTrace': err.stackTrace
    }); {{/analytics}}
    super.onError(err, handler);
  }
}
