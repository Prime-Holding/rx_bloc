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

import '../../feature_splash/services/splash_service.dart';
import '../../lib_auth/blocs/user_account_bloc.dart';
import '../../lib_auth/data_sources/local/auth_token_data_source.dart';
import '../../lib_auth/data_sources/local/auth_token_secure_data_source.dart';
import '../../lib_auth/data_sources/local/auth_token_shared_dara_source.dart';
import '../../lib_auth/data_sources/remote/auth_data_source.dart';
import '../../lib_auth/data_sources/remote/refresh_token_data_source.dart';
import '../../lib_auth/repositories/auth_repository.dart';
import '../../lib_auth/services/access_token_service.dart';
import '../../lib_auth/services/auth_service.dart';
import '../../lib_auth/services/user_account_service.dart'; {{#enable_change_language}}
import '../../lib_change_language/bloc/change_language_bloc.dart';
import '../../lib_change_language/data_sources/language_local_data_source.dart';
import '../../lib_change_language/repositories/language_repository.dart';
import '../../lib_change_language/services/app_language_service.dart'; {{/enable_change_language}}
import '../../lib_permissions/data_sources/remote/permissions_remote_data_source.dart';
import '../../lib_permissions/repositories/permissions_repository.dart';
import '../../lib_permissions/services/permissions_service.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../app/config/environment_config.dart';
import '../common_blocs/coordinator_bloc.dart';
import '../common_mappers/error_mappers/error_mapper.dart';{{#enable_feature_deeplinks}}
import '../common_services/deep_link_service.dart';{{/enable_feature_deeplinks}}
import '../data_sources/local/shared_preferences_instance.dart';{{#enable_feature_counter}}
import '../data_sources/remote/count_remote_data_source.dart';{{/enable_feature_counter}}{{#enable_feature_deeplinks}}
import '../data_sources/remote/deep_link_remote_data_source.dart';{{/enable_feature_deeplinks}}
import '../data_sources/remote/http_clients/api_http_client.dart';
import '../data_sources/remote/http_clients/plain_http_client.dart';
import '../data_sources/remote/push_notification_data_source.dart';{{#enable_feature_counter}}
import '../repositories/counter_repository.dart';{{/enable_feature_counter}}{{#enable_feature_deeplinks}}
import '../repositories/deep_link_repository.dart';{{/enable_feature_deeplinks}}
import '../repositories/push_notification_repository.dart';

class {{project_name.pascalCase()}}WithDependencies extends StatefulWidget {
  const {{project_name.pascalCase()}}WithDependencies({
      required this.config,
      required this.child,
      Key? key,
    }) : super(key: key);

  final EnvironmentConfig config;
  final Widget child;

  @override
  State<{{project_name.pascalCase()}}WithDependencies> createState() =>
      _{{project_name.pascalCase()}}WithDependenciesState();
}

class _{{project_name.pascalCase()}}WithDependenciesState extends State<{{project_name.pascalCase()}}WithDependencies> {
  late GlobalKey<NavigatorState> rootNavigatorKey;
  late GlobalKey<NavigatorState> shellNavigatorKey;

  @override
  void initState() {
    super.initState();
    rootNavigatorKey = GlobalKey<NavigatorState>();
    shellNavigatorKey = GlobalKey<NavigatorState>();
  }

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
      child: widget.child,
    );

  List<SingleChildWidget> get _coordinator => [
        RxBlocProvider<CoordinatorBlocType>(
          create: (context) => CoordinatorBloc(),
        ),
      ];

  SingleChildWidget get _appRouter => Provider<AppRouter>(
        create: (context) => AppRouter(
          coordinatorBloc: context.read(),
          rootNavigatorKey: rootNavigatorKey,
          shellNavigatorKey: shellNavigatorKey,
        ),
      );

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
        Provider<EnvironmentConfig>.value(value: widget.config),
      ];

  List<Provider> get _mappers => [
        Provider<ErrorMapper>(
          create: (context) => ErrorMapper(context.read()),
        ),
      ];

  List<Provider> get _httpClients => [
        Provider<PlainHttpClient>(
          create: (context) {
{{#enable_dev_menu}}
            final storage = SharedPreferencesInstance();{{/enable_dev_menu}}
            return PlainHttpClient({{#enable_dev_menu}}storage{{/enable_dev_menu}});
          },
        ),
        Provider<ApiHttpClient>(
          create: (context) {
{{#enable_dev_menu}}
            final storage = SharedPreferencesInstance();{{/enable_dev_menu}}
            final client = ApiHttpClient({{#enable_dev_menu}}storage{{/enable_dev_menu}})
              ..options.baseUrl = widget.config.baseUrl;
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
            baseUrl: widget.config.baseUrl,
          ),
        ),
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
        ),{{/enable_change_language}}
      ];

  List<Provider> get _services => [
        Provider<AuthService>(
          create: (context) => AuthService(
            context.read(),
          ),
        ),
        Provider<PermissionsService>(
          create: (context) => PermissionsService(
            context.read(),
          ),
        ),
        Provider<UserAccountService>(
          create: (context) => UserAccountService(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
        Provider<AccessTokenService>(
          create: (context) => AccessTokenService(
            context.read(),
          ),
        ),
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
      ];

  List<SingleChildWidget> get _blocs => [
        Provider<RouterBlocType>(
          create: (context) => RouterBloc(
            router: context.read<AppRouter>().router,
            permissionsService: context.read(),
          ),
        ),
        RxBlocProvider<UserAccountBlocType>(
          create: (context) => UserAccountBloc(
            context.read(),
            context.read(),
            context.read(),
            context.read(),
          ),
        ), {{#enable_change_language}}
        RxBlocProvider<ChangeLanguageBlocType>(
          create: (context) => ChangeLanguageBloc(
            languageService: context.read<AppLanguageService>(),
          ),
        ), {{/enable_change_language}}
      ];
}
