{{> licence.dart }}

{{#analytics}}
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';{{/analytics}}
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';{{#enable_pin_code}}
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';{{/enable_pin_code}}

import '../../feature_splash/services/splash_service.dart';
{{#analytics}}
import '../../lib_analytics/blocs/analytics_bloc.dart';
import '../../lib_analytics/repositories/analytics_repository.dart';
import '../../lib_analytics/services/analytics_service.dart';
{{/analytics}}
{{#has_authentication}}
import '../../lib_auth/blocs/user_account_bloc.dart';
import '../../lib_auth/data_sources/local/auth_token_data_source.dart';
import '../../lib_auth/data_sources/local/auth_token_secure_data_source.dart';
import '../../lib_auth/data_sources/local/auth_token_shared_dara_source.dart';
import '../../lib_auth/data_sources/remote/auth_data_source.dart';
import '../../lib_auth/data_sources/remote/refresh_token_data_source.dart';
import '../../lib_auth/repositories/auth_repository.dart';
import '../../lib_auth/services/access_token_service.dart';
import '../../lib_auth/services/auth_service.dart';
import '../../lib_auth/services/user_account_service.dart';{{/has_authentication}}{{#enable_auth_matrix}}
import '../../lib_auth_matrix/data_source/remote/auth_matrix_data_source.dart';
import '../../lib_auth_matrix/repositories/auth_matrix_repository.dart';
import '../../lib_auth_matrix/services/auth_matrix_service.dart';{{/enable_auth_matrix}}{{#enable_change_language}}
import '../../lib_change_language/bloc/change_language_bloc.dart';
import '../../lib_change_language/data_sources/language_local_data_source.dart';
import '../../lib_change_language/repositories/language_repository.dart';
import '../../lib_change_language/services/app_language_service.dart'; {{/enable_change_language}}
import '../../lib_permissions/data_sources/remote/permissions_remote_data_source.dart';
import '../../lib_permissions/repositories/permissions_repository.dart';
import '../../lib_permissions/services/permissions_service.dart';{{#enable_pin_code}}
import '../../lib_pin_code/bloc/create_pin_bloc.dart';
import '../../lib_pin_code/bloc/update_and_verify_pin_bloc.dart';
import '../../lib_pin_code/data_source/pin_biometrics_local_data_source.dart';
import '../../lib_pin_code/data_source/pin_code_data_source.dart';
import '../../lib_pin_code/repository/pin_biometrics_repository.dart';
import '../../lib_pin_code/repository/pin_code_repository.dart';
import '../../lib_pin_code/services/create_pin_code_service.dart';
import '../../lib_pin_code/services/pin_biometrics_service.dart';
import '../../lib_pin_code/services/update_and_verify_pin_code_service.dart';{{/enable_pin_code}}
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../../lib_router/services/router_service.dart';
import '../app/config/environment_config.dart';
import '../common_blocs/coordinator_bloc.dart';
import '../common_blocs/push_notifications_bloc.dart';
import '../common_mappers/error_mappers/error_mapper.dart';{{#enable_feature_deeplinks}}
import '../common_services/deep_link_service.dart';{{/enable_feature_deeplinks}}
import '../common_services/push_notifications_service.dart';
import '../data_sources/local/profile_local_data_source.dart';
import '../data_sources/local/shared_preferences_instance.dart';{{#enable_feature_counter}}
import '../data_sources/remote/count_remote_data_source.dart';{{/enable_feature_counter}}{{#enable_feature_deeplinks}}
import '../data_sources/remote/deep_link_remote_data_source.dart';{{/enable_feature_deeplinks}}
import '../data_sources/remote/http_clients/api_http_client.dart';
import '../data_sources/remote/http_clients/plain_http_client.dart';
import '../data_sources/remote/push_notification_data_source.dart';{{#enable_feature_counter}}
import '../repositories/counter_repository.dart';{{/enable_feature_counter}}{{#enable_feature_deeplinks}}
import '../repositories/deep_link_repository.dart';{{/enable_feature_deeplinks}}
import '../repositories/push_notification_repository.dart';

class {{project_name.pascalCase()}}WithDependencies extends StatelessWidget {
  const {{project_name.pascalCase()}}WithDependencies({
      required this.config,
      required this.child,
      Key? key,
    }) : super(key: key);

  final EnvironmentConfig config;
  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
    /// List of all providers used throughout the app
    providers: [
        ..._coordinator,
        _appRouter,{{#analytics}}
        ..._analytics,{{/analytics}}
        ..._environment,
        ..._mappers,
        ..._httpClients,
        ..._dataStorages,
        ..._dataSources,
        ..._repositories,
        ..._services,
        ..._blocs,
      ],
      child: child,
    );

  List<SingleChildWidget> get _coordinator => [
        RxBlocProvider<CoordinatorBlocType>(
          create: (context) => CoordinatorBloc(),
        ),
      ];

  SingleChildWidget get _appRouter => Provider<AppRouter>(
        create: (context) => AppRouter(
          coordinatorBloc: context.read(),
        ),
      );

  {{#analytics}}
  List<Provider> get _analytics => [
        Provider<FirebaseAnalytics>(create: (context) => FirebaseAnalytics.instance),
        Provider<FirebaseAnalyticsObserver>(
          create: (context) =>
              FirebaseAnalyticsObserver(analytics: context.read()),
        ),
        Provider<FirebaseCrashlytics>(create: (context) => FirebaseCrashlytics.instance),
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

  List<Provider> get _dataSources => [{{#has_authentication}}
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
            baseUrl: config.baseUrl,
          ),
        ),{{/has_authentication}}
        Provider<PushNotificationsDataSource>(
          create: (context) => PushNotificationsDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),
        {{#enable_feature_counter}}
        Provider<CountRemoteDataSource>(
          create: (context) => CountRemoteDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),
        {{/enable_feature_counter}}
        Provider<PermissionsRemoteDataSource>(
          create: (context) => PermissionsRemoteDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),
        {{#enable_feature_deeplinks}}
        Provider<DeepLinkRemoteDataSource>(
          create: (context) => DeepLinkRemoteDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),
        {{/enable_feature_deeplinks}} {{#enable_change_language}}
        Provider<LanguageLocalDataSource>(
          create: (context) => LanguageLocalDataSource(
          context.read<SharedPreferencesInstance>()),
        ),{{/enable_change_language}}
        Provider<ProfileLocalDataSource>(
          create: (context) =>
              ProfileLocalDataSource(context.read<SharedPreferencesInstance>()),
        ),{{#enable_pin_code}}
        Provider<BiometricsLocalDataSource>(
          create: (context) => PinBiometricsLocalDataSource(
          context.read<SharedPreferencesInstance>()),
        ),
        Provider<PinCodeDataSource>(
          create: (context) => PinCodeDataSource(
            context.read<FlutterSecureStorage>(),
          ),
        ),{{/enable_pin_code}}{{#enable_auth_matrix}}
         Provider<AuthMatrixDataSource>(
          create: (context) => AuthMatrixDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),{{/enable_auth_matrix}}
      ];

  List<Provider> get _repositories => [{{#has_authentication}}
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            context.read(),
            context.read(),
            context.read(),
            context.read(),
          ),
        ),{{/has_authentication}}
        Provider<PushNotificationRepository>(
          create: (context) => PushNotificationRepository(
            context.read(),
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
        {{#enable_feature_counter}}
        Provider<CounterRepository>(
          create: (context) => CounterRepository(
            context.read(),
            context.read(),
          ),
        ),
        {{/enable_feature_counter}}
        Provider<PermissionsRepository>(
          create: (context) => PermissionsRepository(
            context.read(),
            context.read(),
          ),
        ),
        {{#enable_feature_deeplinks}}
        Provider<DeepLinkRepository>(
          create: (context) => DeepLinkRepository(
            context.read(),
            context.read(),
          ),
        ),
        {{/enable_feature_deeplinks}} {{#enable_change_language}}
        Provider<LanguageRepository>(
          create: (context) => LanguageRepository(
            context.read<ErrorMapper>(),
            context.read<LanguageLocalDataSource>(),
          ),
        ),{{/enable_change_language}} {{#enable_pin_code}}
        Provider<PinCodeRepository>(
          create: (context) => PinCodeRepository(
            context.read<ErrorMapper>(),
            context.read<PinCodeDataSource>(),
          ),
        ),
        Provider<PinBiometricsRepository>(
          create: (context) => PinBiometricsRepository(
            context.read<BiometricsLocalDataSource>(),
          ),
        ),{{/enable_pin_code}}{{#enable_auth_matrix}}
        Provider<AuthMatrixRepository>(
          create: (context) => AuthMatrixRepository(
            context.read(),
            context.read<ErrorMapper>(),
          ),
        ),{{/enable_auth_matrix}}
        {{#analytics}}
        Provider<AnalyticsRepository>(
          create: (context) => AnalyticsRepository(
            context.read<ErrorMapper>(),
            context.read<FirebaseCrashlytics>(),
            context.read<FirebaseAnalytics>(),
          ),
        ),
        {{/analytics}}
      ];

  List<Provider> get _services => [{{#has_authentication}}
        Provider<AuthService>(
          create: (context) => AuthService(
            context.read(),
          ),
        ),{{/has_authentication}}
        Provider<PermissionsService>(
          create: (context) => PermissionsService(
            context.read(),
          ),
        ),{{#has_authentication}}
        Provider<RouterService>(
          create: (context) => RouterService(
            context.read<AppRouter>().router,
            context.read(),
          ),
        ),
        Provider<UserAccountService>(
          create: (context) => UserAccountService(
            context.read(),
            context.read(),{{#analytics}}
            context.read(),{{/analytics}}
            context.read(),
          ),
        ),
        Provider<AccessTokenService>(
          create: (context) => AccessTokenService(
            context.read(),
          ),
        ),{{/has_authentication}}
        Provider<SplashService>(
          create: (context) => SplashService(
            context.read(),
          ),
        ),
        {{#enable_feature_deeplinks}}
        Provider<DeepLinkService>(
          create: (context) => DeepLinkService(
            context.read(),
          ),
        ),{{/enable_feature_deeplinks}} {{#enable_change_language}}
        Provider<AppLanguageService>(
          create: (context) => AppLanguageService(
            languageRepository: context.read<LanguageRepository>(),
          ),
        ), {{/enable_change_language}}
        Provider<PushNotificationsService>(
          create: (context) => PushNotificationsService(
            context.read(),
          ),
        ), {{#enable_pin_code}}
        Provider<CreatePinCodeService>(
          create: (context) => CreatePinCodeService(
            context.read<PinCodeRepository>(),
          ),
        ),
        Provider<UpdateAndVerifyPinCodeService>(
          create: (context) => UpdateAndVerifyPinCodeService(
            context.read<PinCodeRepository>(),
          ),
        ),
        Provider<PinBiometricsService>(
          create: (context) => PinBiometricsService(
            context.read<PinBiometricsRepository>(),
          ),
        ),{{/enable_pin_code}}{{#enable_auth_matrix}}
         Provider<AuthMatrixService>(
          create: (context) => AuthMatrixService(
            context.read<AuthMatrixRepository>(),
            context.read<RouterService>(),
          ),
          dispose: (context, value) => value.dispose(),
        ),{{/enable_auth_matrix}}
        {{#analytics}}
        Provider<AnalyticsService>(
          create: (context) => AnalyticsService(
            context.read(),
          ),
        ),
        {{/analytics}}
      ];

  List<SingleChildWidget> get _blocs => [
        Provider<RouterBlocType>(
          create: (context) => RouterBloc(
            router: context.read<AppRouter>().router,
            permissionsService: context.read(),
          ),
        ),{{#has_authentication}}
        RxBlocProvider<UserAccountBlocType>(
          create: (context) => UserAccountBloc(
            context.read(),
            context.read(),
            context.read(),
            context.read(),
          ),
        ),{{/has_authentication}}{{#enable_change_language}}
        RxBlocProvider<ChangeLanguageBlocType>(
          create: (context) => ChangeLanguageBloc(
            languageService: context.read<AppLanguageService>(),
          ),
        ), {{/enable_change_language}}
        RxBlocProvider<PushNotificationsBlocType>(
          create: (context) => PushNotificationsBloc(
            context.read(),
          ),
        ), {{#enable_pin_code}}
        RxBlocProvider<CreatePinBlocType>(
          create: (context) => CreatePinBloc(
            service: context.read<CreatePinCodeService>(),
            coordinatorBloc: context.read<CoordinatorBlocType>(),
          ),
        ),
        RxBlocProvider<UpdateAndVerifyPinBlocType>(
          create: (context) => UpdateAndVerifyPinBloc(
            service: context.read<UpdateAndVerifyPinCodeService>(),
            pinBiometricsService: context.read<PinBiometricsService>(),
            coordinatorBloc: context.read<CoordinatorBlocType>(),
          ),
        ),{{/enable_pin_code}}
        {{#analytics}}
        RxBlocProvider<AnalyticsBlocType>(
          create: (context) => AnalyticsBloc(
            context.read(),
            context.read(),
          ),
        ),
        {{/analytics}}
      ];
}
