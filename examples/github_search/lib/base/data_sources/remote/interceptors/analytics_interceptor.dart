// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

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
  AnalyticsInterceptor( this.observer );
  
  final FirebaseAnalyticsObserver observer;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) { 
    observer.analytics.logEvent(name: 'dioError', parameters: {
      'errorType': err.type,
      'errorMessage': err.message,
      'stackTrace': err.stackTrace
    }); 
    super.onError(err, handler);
  }
}
