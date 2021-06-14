// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../common_use_cases/fetch_access_token_use_case.dart';
import '../common_use_cases/logout_use_case.dart';
import '../data_sources/local/auth_token_data_source.dart';
import '../data_sources/local/auth_token_secure_data_source.dart';
import '../data_sources/local/auth_token_shared_dara_source.dart';
import '../data_sources/remote/interceptors/analytics_interceptor.dart';
import '../data_sources/remote/interceptors/auth_interceptor.dart';
import '../repositories/auth_repository.dart';

class AppDependencies {
  AppDependencies._(this.context);

  factory AppDependencies.of(BuildContext context) =>
      _instance != null ? _instance! : _instance = AppDependencies._(context);

  static AppDependencies? _instance;

  final BuildContext context;

  /// List of all providers used throughout the app
  List<SingleChildWidget> get providers => [
    ..._analytics,
    ..._dataSources,
    ..._repositories,
    ..._useCases,
    ..._httpClients,
  ];

  List<Provider> get _analytics => [
    Provider<FirebaseAnalytics>(create: (context) => FirebaseAnalytics()),
    Provider<FirebaseAnalyticsObserver>(
      create: (context) =>
          FirebaseAnalyticsObserver(analytics: context.read()),
    ),
  ];

  /// Use different data source regarding of if it is running in web ot not
  List<Provider> get _dataSources => [
    Provider<AuthTokenDataSource>(
        create: (context) =>
        kIsWeb
            ? AuthTokenSharedDataSource()
            : AuthTokenSecureDataSource()),
  ];

  List<Provider> get _repositories => [
    Provider<AuthRepository>(
        create: (context) => AuthRepository(context.read())),
  ];

  List<Provider> get _useCases => [
    Provider<LogoutUseCase>(
        create: (context) => LogoutUseCase(context.read())),
    Provider<FetchAccessTokenUseCase>(
        create: (context) => FetchAccessTokenUseCase(context.read())),
  ];

  List<Provider> get _httpClients => [
    Provider<Dio>(create: (context) {
      final _dio = Dio();
      _dio.interceptors
        ..add(AuthInterceptor(context.read(), context.read()))
        ..add(AnalyticsInterceptor(context.read()));
      return _dio;
    }),
  ];
}
