{{> licence.dart }}

{{#analytics}}
import 'package:firebase_analytics/firebase_analytics.dart';{{/analytics}}
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../app/config/environment_config.dart';
import '../common_blocs/coordinator_bloc.dart';
import '../common_blocs/user_account_bloc.dart';
import '../common_mappers/error_mappers/error_mapper.dart';
import '../common_use_cases/check_access_token_expiration_use_case.dart';
import '../common_use_cases/fetch_access_token_use_case.dart';
import '../common_use_cases/login_use_case.dart';
import '../common_use_cases/logout_use_case.dart';
import '../common_use_cases/refresh_access_token_use_case.dart';
import '../data_sources/local/auth_token_data_source.dart';
import '../data_sources/local/auth_token_secure_data_source.dart';
import '../data_sources/local/auth_token_shared_dara_source.dart';
import '../data_sources/local/shared_preferences_instance.dart';
import '../data_sources/remote/auth_data_source.dart';
import '../data_sources/remote/http_clients/api_http_client.dart';
import '../data_sources/remote/http_clients/plain_http_client.dart';
import '../data_sources/remote/push_notification_data_source.dart';
import '../data_sources/remote/refresh_token_data_source.dart';
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
        ..._coordinator,{{#analytics}}
        ..._analytics,{{/analytics}}
        ..._environment,
        ..._mappers,
        ..._httpClients,
        ..._dataStorages,
        ..._dataSources,
        ..._repositories,
        ..._useCases,
        ..._blocs,
      ];

  List<SingleChildWidget> get _coordinator => [
        RxBlocProvider<CoordinatorBlocType>(
          create: (context) => CoordinatorBloc(),
        ),
      ];

  {{#analytics}}
  List<Provider> get _analytics => [
        Provider<FirebaseAnalytics>(create: (context) => FirebaseAnalytics.instance),
        Provider<FirebaseAnalyticsObserver>(
          create: (context) =>
              FirebaseAnalyticsObserver(analytics: context.read()),
        ),
      ];
  {{/analytics}}

  List<Provider> get _environment => [
        Provider<EnvironmentConfig>.value(value: config),
      ];

  List<Provider> get _mappers => [
        Provider<ErrorMapper>(
          create: (context) => ErrorMapper(context.read()),
        ),
      ];

  List<Provider> get _httpClients => [
        Provider<PlainHttpClient>(
          create: (context) {
            return PlainHttpClient();
          },
        ),
        Provider<ApiHttpClient>(
          create: (context) {
            final client = ApiHttpClient()
              ..options.baseUrl = config.baseUrl;
            return client;
          },
        ),
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

  List<Provider> get _dataSources => [
        // Use different data source depending on the platform.
        Provider<AuthTokenDataSource>(
            create: (context) => kIsWeb
                ? AuthTokenSharedDataSource(context.read())
                : AuthTokenSecureDataSource(context.read())),
        Provider<AuthDataSource>(
          create: (context) => AuthDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),
        Provider<RefreshTokenDataSource>(
          create: (context) => RefreshTokenDataSource(
            context.read<PlainHttpClient>(),
          ),
        ),
        Provider<PushNotificationsDataSource>(
          create: (context) => PushNotificationsDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),
      ];

  List<Provider> get _repositories => [
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            context.read(),
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
        Provider<PushNotificationRepository>(
          create: (context) => PushNotificationRepository(
            context.read(),
            context.read(),
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
        Provider<CheckAccessTokenExpirationUseCase>(
          create: (context) => CheckAccessTokenExpirationUseCase(),
        ),
        Provider<FetchAccessTokenUseCase>(
          create: (context) => FetchAccessTokenUseCase(context.read()),
        ),
        Provider<RefreshAccessTokenUseCase>(
          create: (context) => RefreshAccessTokenUseCase(context.read()),
        ),
      ];

  List<SingleChildWidget> get _blocs => [
        RxBlocProvider<UserAccountBlocType>(
          create: (context) => UserAccountBloc(
            logoutUseCase: context.read(),
            coordinatorBloc: context.read(),
            authRepository: context.read(),
          ),
        ),
      ];
}
