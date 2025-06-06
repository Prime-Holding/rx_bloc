{{> licence.dart }}

{{#analytics}}
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';{{/analytics}}
import 'package:firebase_messaging/firebase_messaging.dart';{{#has_authentication}}
import 'package:flutter/foundation.dart';{{/has_authentication}}
import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';{{#enable_pin_code}}
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';

import '../../feature_pin_code/repository/pin_biometrics_repository.dart';
import '../../feature_pin_code/services/verify_pin_code_service.dart';{{/enable_pin_code}}
import '../../feature_splash/services/splash_service.dart';{{#analytics}}
import '../../lib_analytics/blocs/analytics_bloc.dart';
import '../../lib_analytics/repositories/analytics_repository.dart';
import '../../lib_analytics/services/analytics_service.dart';{{/analytics}}{{#has_authentication}}
import '../../lib_auth/blocs/user_account_bloc.dart';
import '../../lib_auth/data_sources/local/auth_token_data_source.dart';
import '../../lib_auth/data_sources/local/auth_token_secure_data_source.dart';
import '../../lib_auth/data_sources/local/auth_token_shared_dara_source.dart';
import '../../lib_auth/data_sources/remote/auth_data_source.dart';
import '../../lib_auth/data_sources/remote/refresh_token_data_source.dart';
import '../../lib_auth/repositories/auth_repository.dart';
import '../../lib_auth/services/access_token_service.dart';
import '../../lib_auth/services/auth_service.dart';
import '../../lib_auth/services/user_account_service.dart';{{/has_authentication}}{{#enable_change_language}}
import '../../lib_change_language/bloc/change_language_bloc.dart';
import '../../lib_change_language/data_sources/language_local_data_source.dart';
import '../../lib_change_language/repositories/language_repository.dart';
import '../../lib_change_language/services/app_language_service.dart'; {{/enable_change_language}}{{#enable_mfa}}
import '../../lib_mfa/data_source/remote/mfa_data_source.dart';
import '../../lib_mfa/repositories/mfa_repository.dart';
import '../../lib_mfa/services/mfa_service.dart';{{/enable_mfa}}
import '../../lib_permissions/data_sources/remote/permissions_remote_data_source.dart';
import '../../lib_permissions/repositories/permissions_repository.dart';
import '../../lib_permissions/services/permissions_service.dart';
import '../../lib_router/router.dart';{{#has_authentication}}
import '../../lib_router/services/router_service.dart';{{/has_authentication}}{{#enable_remote_translations}}
import '../../lib_translations/di/translations_dependencies.dart';{{/enable_remote_translations}}
import '../app/config/environment_config.dart';
import '../common_blocs/coordinator_bloc.dart';
import '../common_blocs/push_notifications_bloc.dart';
import '../common_mappers/error_mappers/error_mapper.dart';{{#enable_feature_deeplinks}}
import '../common_services/app_links_service.dart';
import '../common_services/deep_link_service.dart';{{/enable_feature_deeplinks}}
import '../common_services/push_notifications_service.dart';{{#enable_feature_deeplinks}}
import '../data_sources/local/app_links_data_source.dart';{{/enable_feature_deeplinks}}{{#enable_feature_onboarding}}
import '../common_services/onboarding_service.dart';{{/enable_feature_onboarding}}
import '../data_sources/local/notifications_local_data_source.dart';{{#enable_pin_code}}
import '../data_sources/local/pin_biometrics_local_data_source.dart';
import '../data_sources/local/pin_code_local_data_source.dart';{{/enable_pin_code}}
import '../data_sources/local/shared_preferences_instance.dart';{{#enable_feature_onboarding}}
import '../data_sources/local/url_launcher_local_data_source.dart';
import '../data_sources/remote/country_codes_remote_data_source.dart';{{/enable_feature_onboarding}}{{#enable_feature_counter}}
import '../data_sources/remote/count_remote_data_source.dart';{{/enable_feature_counter}}{{#enable_feature_deeplinks}}
import '../data_sources/remote/deep_link_remote_data_source.dart';{{/enable_feature_deeplinks}}
import '../data_sources/remote/http_clients/api_http_client.dart';
import '../data_sources/remote/http_clients/plain_http_client.dart';{{#enable_forgotten_password}}
import '../data_sources/remote/password_reset_remote_data_source.dart';{{/enable_forgotten_password}}{{#enable_pin_code}}
import '../data_sources/remote/pin_code_data_source.dart';{{/enable_pin_code}}
import '../data_sources/remote/push_notification_data_source.dart';{{#enable_feature_onboarding}}
import '../data_sources/remote/register_remote_data_source.dart';
import '../data_sources/remote/users_remote_data_source.dart';{{/enable_feature_onboarding}}{{#enable_feature_deeplinks}}
import '../repositories/app_links_repository.dart';{{/enable_feature_deeplinks}}{{#enable_feature_counter}}
import '../repositories/counter_repository.dart';{{/enable_feature_counter}}{{#enable_feature_deeplinks}}
import '../repositories/deep_link_repository.dart';{{/enable_feature_deeplinks}} {{#enable_feature_onboarding}}
import '../repositories/open_mail_app_repository.dart'; {{/enable_feature_onboarding}}{{#enable_forgotten_password}}
import '../repositories/password_reset_repository.dart';{{/enable_forgotten_password}}
import '../repositories/push_notification_repository.dart';{{#enable_pin_code}}
import '../repositories/pin_code_repository.dart';{{/enable_pin_code}}{{#enable_feature_onboarding}}
import '../repositories/url_launcher_repository.dart';
import '../repositories/register_repository.dart';
import '../repositories/users_repository.dart';{{/enable_feature_onboarding}}

class {{project_name.pascalCase()}}WithDependencies extends StatelessWidget {
  const {{project_name.pascalCase()}}WithDependencies({
      required this.config,
      required this.child,
      super.key,
  });

  final EnvironmentConfig config;
  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
    /// List of all providers used throughout the app
    providers: [
        ..._coordinator,
        _appRouter,
        Provider<GoRouter>(
            create: (context) => context.read<AppRouter>().router,
          ),{{#analytics}}
        ..._analytics,{{/analytics}}
        ..._environment,
        ..._mappers,
        ..._httpClients,
        ..._dataStorages,
        ..._libs,
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

  List<SingleChildWidget> get _libs => [{{#enable_remote_translations}}
      ...TranslationsDependencies.from(baseUrl: config.baseUrl).providers,{{/enable_remote_translations}}
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
        Provider<NotificationsLocalDataSource>(
          create: (context) =>
              NotificationsLocalDataSource(context.read<SharedPreferencesInstance>()),
        ),{{#enable_pin_code}}
        Provider<BiometricsLocalDataSource>(
          create: (context) => PinBiometricsLocalDataSource(
          context.read<SharedPreferencesInstance>()),
        ),
        Provider<PinCodeLocalDataSource>(
          create: (context) => PinCodeLocalDataSource(
            context.read<FlutterSecureStorage>(),
          ),
        ),
        Provider<PinCodeDataSource>(
          create: (context) => PinCodeDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),{{/enable_pin_code}}{{#enable_mfa}}
         Provider<MfaDataSource>(
          create: (context) => MfaDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),{{/enable_mfa}}{{#enable_feature_onboarding}}
        Provider<CountryCodesRemoteDataSource>(
          create: (context) => CountryCodesRemoteDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),
        Provider<UsersRemoteDataSource>(
          create: (context) => UsersRemoteDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),
        Provider<RegisterRemoteDataSource>(
          create: (context) => RegisterRemoteDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),
        Provider<UrlLauncherLocalDataSource>(
          create: (context) => UrlLauncherLocalDataSource(),
        ),{{/enable_feature_onboarding}}{{#enable_feature_deeplinks}}
        Provider<AppLinksDataSource>(
          create: (context) => AppLinksDataSource(),
        ),{{/enable_feature_deeplinks}}{{#enable_forgotten_password}}
        Provider<PasswordResetRemoteDataSource>(
          create: (context) => PasswordResetRemoteDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),{{/enable_forgotten_password}}
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
            context.read<PinCodeLocalDataSource>(),
            context.read<PinCodeDataSource>(),
          ),
        ),
        Provider<PinBiometricsRepository>(
          create: (context) => PinBiometricsRepository(
            context.read<BiometricsLocalDataSource>(),
          ),
        ),{{/enable_pin_code}}{{#enable_mfa}}
        Provider<MfaRepository>(
          create: (context) => MfaRepository(
            context.read(),
            context.read<ErrorMapper>(),
          ),
        ),{{/enable_mfa}}
        {{#analytics}}
        Provider<AnalyticsRepository>(
          create: (context) => AnalyticsRepository(
            context.read<ErrorMapper>(),
            context.read<FirebaseCrashlytics>(),
            context.read<FirebaseAnalytics>(),
          ),
        ),
        {{/analytics}}{{#enable_feature_onboarding}}
        Provider<UsersRepository>(
          create: (context) => UsersRepository(
            context.read(),
            context.read(),
          ),
        ),
        Provider<RegisterRepository>(
          create: (context) => RegisterRepository(
            context.read(),
            context.read(),
          ),
        ),
        Provider<UrlLauncherRepository>(
          create: (context) => UrlLauncherRepository(
            context.read(),
            context.read(),
          ),
        ),
         Provider<OpenMailAppRepository>(
          create: (context) => OpenMailAppRepository(
            context.read(),
          ),
        ),{{/enable_feature_onboarding}}{{#enable_feature_deeplinks}}
        Provider<AppLinksRepository>(
          create: (context) => AppLinksRepository(
            context.read(),
          ),
        ),{{/enable_feature_deeplinks}}{{#enable_forgotten_password}}
        Provider<PasswordResetRepository>(
          create: (context) => PasswordResetRepository(
            context.read(),
            context.read(),
          ),
        ),{{/enable_forgotten_password}}
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
          context.read(),{{#enable_remote_translations}}
          context.read(),{{/enable_remote_translations}}
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
        Provider<VerifyPinCodeService>(
          create: (context) => VerifyPinCodeService(
            context.read<PinCodeRepository>(),
          ),
        ), {{/enable_pin_code}}{{#enable_mfa}}
         Provider<MfaService>(
          create: (context) => MfaService(
            context.read<MfaRepository>(),
            context.read<RouterService>(),
          ),
          dispose: (context, value) => value.dispose(),
        ),{{/enable_mfa}}
        {{#analytics}}
        Provider<AnalyticsService>(
          create: (context) => AnalyticsService(
            context.read(),
          ),
        ),
        {{/analytics}}{{#enable_feature_onboarding}}
        Provider<OnboardingService>(
          create: (context) => OnboardingService(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),{{/enable_feature_onboarding}}{{#enable_feature_deeplinks}}
         Provider<AppLinksService>(
          create: (context) => AppLinksService(
            context.read(),
          ),
          dispose: (context, value) => value.dispose(),
        ),{{/enable_feature_deeplinks}}
      ];

  List<SingleChildWidget> get _blocs => [ {{#has_authentication}}
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
        ), {{#analytics}}
        RxBlocProvider<AnalyticsBlocType>(
          create: (context) => AnalyticsBloc(
            context.read(),
            context.read(),
          ),
        ), {{/analytics}}
      ];
}
