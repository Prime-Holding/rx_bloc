// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../common_use_cases/fetch_new_access_token_use_case.dart';
import '../common_use_cases/logout_use_case.dart';
import '../data_sources/local/auth_token_data_source.dart';
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
        ..._authDataSource,
        ..._authRepo,
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

  List<Provider> get _authDataSource => [
        Provider<AuthTokenDataSource>(
            create: (context) =>
                AuthTokenDataSource(const FlutterSecureStorage())),
      ];

  List<Provider> get _authRepo => [
        Provider<AuthRepository>(
            create: (context) => AuthRepository(context.read())),
      ];

  List<Provider> get _useCases => [
        Provider<LogoutUseCase>(
            create: (context) => LogoutUseCase(context.read())),
        Provider<fetchNewAccessTokenUseCase>(
            create: (context) => fetchNewAccessTokenUseCase(context.read())),
      ];

  List<Provider> get _httpClients => [
        Provider<Dio>(create: (context) {
          final _dio = Dio();
          _dio.interceptors
            ..add(
                AuthInterceptor(context.read(), context.read(), context.read()))
            ..add(AnalyticsInterceptor());
          return _dio;
        }),
      ];
}
