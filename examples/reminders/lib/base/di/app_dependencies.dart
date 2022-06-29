// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../feature_reminder_manage/blocs/reminder_manage_bloc.dart';
import '../app/config/environment_config.dart';
import '../common_blocs/coordinator_bloc.dart';
import '../common_blocs/firebase_bloc.dart';
import '../common_blocs/user_account_bloc.dart';
import '../common_use_cases/fetch_access_token_use_case.dart';
import '../common_use_cases/login_use_case.dart';
import '../common_use_cases/logout_use_case.dart';
import '../data_sources/local/auth_token_data_source.dart';
import '../data_sources/local/auth_token_secure_data_source.dart';
import '../data_sources/local/auth_token_shared_dara_source.dart';
import '../data_sources/local/reminders_local_data_source.dart';
import '../data_sources/local/shared_preferences_instance.dart';
import '../data_sources/remote/auth_data_source.dart';
import '../data_sources/remote/interceptors/analytics_interceptor.dart';
import '../data_sources/remote/interceptors/auth_interceptor.dart';
import '../data_sources/remote/push_notification_data_source.dart';
import '../data_sources/remote/reminders_firebase_data_source.dart';
import '../data_sources/remote/reminders_remote_data_source_factory.dart';
import '../repositories/auth_repository.dart';
import '../repositories/firebase_repository.dart';
import '../repositories/push_notification_repository.dart';
import '../repositories/reminders_repository.dart';
import '../services/firebase_service.dart';
import '../services/reminders_service.dart';

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
        ..._services,
        ..._useCases,
        ..._blocs,
        ..._interceptors,
      ];

  List<Provider> get _analytics => config == EnvironmentConfig.dev
      ? []
      : [
          Provider<FirebaseAnalytics>(
              create: (context) => FirebaseAnalytics.instance),
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
        if (config != EnvironmentConfig.dev)
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
        Provider<RemindersLocalDataSource>(
          create: (context) => RemindersLocalDataSource(),
        ),
        Provider<RemindersFirebaseDataSource>(
          create: (context) => RemindersFirebaseDataSource(),
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
        Provider<RemindersRepository>(
          create: (context) => RemindersRepository(
            dataSource: RemindersRemoteDataSourceFactory.fromConfig(config),
          ),
        ),
        Provider<FirebaseRepository>(
          create: (context) => FirebaseRepository(
            dataSource: context.read(),
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

  List<Provider> get _services => [
        Provider<RemindersService>(
          create: (context) => RemindersService(
            context.read(),
          ),
        ),
        Provider<FirebaseService>(
          create: (context) => FirebaseService(
            context.read(),
          ),
        ),
      ];

  List<SingleChildWidget> get _blocs => [
        RxBlocProvider<CoordinatorBlocType>(
          create: (context) => CoordinatorBloc(),
        ),
        RxBlocProvider<ReminderManageBlocType>(
          create: (context) => ReminderManageBloc(
            context.read(),
            context.read(),
          ),
        ),
        RxBlocProvider<UserAccountBlocType>(
          create: (context) => UserAccountBloc(
            logoutUseCase: context.read(),
            coordinatorBloc: context.read(),
            authRepository: context.read(),
          ),
        ),
        if (config != EnvironmentConfig.dev)
          RxBlocProvider<FirebaseBlocType>(
            create: (context) => FirebaseBloc(
              context.read(),
              context.read(),
            ),
            lazy: false,
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
