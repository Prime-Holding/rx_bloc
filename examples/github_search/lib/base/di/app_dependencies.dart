// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:github_search/base/data_sources/remote/github_repos_data_source.dart';
import 'package:github_search/base/repositories/github_repos_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../app/config/environment_config.dart';
import '../common_blocs/coordinator_bloc.dart';
import '../common_blocs/user_account_bloc.dart';
import '../common_use_cases/fetch_access_token_use_case.dart';
import '../common_use_cases/login_use_case.dart';
import '../common_use_cases/logout_use_case.dart';
import '../data_sources/local/auth_token_data_source.dart';
import '../data_sources/local/auth_token_secure_data_source.dart';
import '../data_sources/local/auth_token_shared_dara_source.dart';
import '../data_sources/local/shared_preferences_instance.dart';
import '../data_sources/remote/auth_data_source.dart';
import '../data_sources/remote/interceptors/analytics_interceptor.dart';
import '../data_sources/remote/interceptors/auth_interceptor.dart';
import '../data_sources/remote/push_notification_data_source.dart';
import '../repositories/auth_repository.dart';
import '../repositories/push_notification_repository.dart';

class AppDependencies {
  AppDependencies._(this.context, this.config);

  factory AppDependencies.of(
          BuildContext context, EnvironmentConfig envConfig) =>
      _instance != null
          ? _instance!
          : _instance = AppDependencies._(context, envConfig);

  static AppDependencies? _instance;

  final BuildContext context;
  final EnvironmentConfig config;

  /// List of all providers used throughout the app
  List<SingleChildWidget> get providers => [
        ..._analytics,
        ..._httpClients,
        ..._dataStorages,
        ..._dataSources,
        ..._repositories,
        ..._useCases,
        ..._blocs,
        ..._interceptors,
      ];

  List<Provider> get _analytics => [
        Provider<FirebaseAnalytics>(create: (context) => FirebaseAnalytics.instance),
        Provider<FirebaseAnalyticsObserver>(
          create: (context) =>
              FirebaseAnalyticsObserver(analytics: context.read()),
        ),
      ];

  List<Provider> get _httpClients => [
        Provider<Dio>(create: (context) => Dio()),
      ];

  List<SingleChildWidget> get _dataStorages => [
        Provider<SharedPreferencesInstance>(
            create: (context) => SharedPreferencesInstance()),
        Provider<FlutterSecureStorage>(
            create: (context) => const FlutterSecureStorage()),
        Provider<FirebaseMessaging>(
          create: (_) => FirebaseMessaging.instance,
        ),
      ];

  /// Use different data source regarding of if it is running in web ot not
  List<Provider> get _dataSources => [
        Provider<AuthTokenDataSource>(
            create: (context) => kIsWeb
                ? AuthTokenSharedDataSource(context.read())
                : AuthTokenSecureDataSource(context.read())),
        Provider<AuthDataSource>(
          create: (context) => AuthDataSource(
            context.read(),
            baseUrl: config.baseApiUrl,
          ),
        ),
        Provider<PushNotificationsDataSource>(
          create: (context) => PushNotificationsDataSource(context.read(),
              baseUrl: config.baseApiUrl),
        ),
        Provider<GithubReposDataSource>(
          create: (context) => GithubReposDataSource(
            context.read(),
          ),
        ),
      ];

  List<Provider> get _repositories => [
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            authDataSource: context.read(),
            authTokenDataSource: context.read(),
          ),
        ),
        Provider<PushNotificationRepository>(
          create: (context) => PushNotificationRepository(
            context.read(),
            context.read(),
          ),
        ),
        Provider<GithubReposRepository>(
          create: (context) => GithubReposRepository(
            context.read(),
          ),
        ),
      ];

  List<Provider> get _useCases => [
        Provider<LoginUseCase>(
            create: (context) => LoginUseCase(
                  context.read(),
                  context.read(),
                )),
        Provider<LogoutUseCase>(
            create: (context) => LogoutUseCase(
                  context.read(),
                  context.read(),
                )),
        Provider<FetchAccessTokenUseCase>(
          create: (context) => FetchAccessTokenUseCase(context.read()),
        ),
      ];

  List<SingleChildWidget> get _blocs => [
        RxBlocProvider<CoordinatorBlocType>(
          create: (context) => CoordinatorBloc(),
        ),
        RxBlocProvider<UserAccountBlocType>(
          create: (context) => UserAccountBloc(
            logoutUseCase: context.read(),
            coordinatorBloc: context.read(),
            authRepository: context.read(),
          ),
        ),
      ];

  List<Provider> get _interceptors => [
        Provider<AuthInterceptor>(
          create: (context) => AuthInterceptor(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
        Provider<AnalyticsInterceptor>(
          create: (context) => AnalyticsInterceptor(context.read()),
        ),
      ];
}
