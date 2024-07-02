// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../feature_splash/services/splash_service.dart';
import '../../lib_permissions/data_sources/remote/permissions_remote_data_source.dart';
import '../../lib_permissions/repositories/permissions_repository.dart';
import '../../lib_permissions/services/permissions_service.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../../lib_todo_actions/blocs/todo_actions_bloc.dart';
import '../../lib_todo_actions/services/todo_actions_service.dart';
import '../../lib_translations/di/translations_dependencies.dart';
import '../app/config/environment_config.dart';
import '../common_blocs/coordinator_bloc.dart';
import '../common_blocs/push_notifications_bloc.dart';
import '../common_mappers/error_mappers/error_mapper.dart';
import '../common_services/push_notifications_service.dart';
import '../common_services/todo_list_service.dart';
import '../data_sources/local/profile_local_data_source.dart';
import '../data_sources/local/shared_preferences_instance.dart';
import '../data_sources/local/todo_list_local_data_source.dart';
import '../data_sources/remote/http_clients/api_http_client.dart';
import '../data_sources/remote/http_clients/plain_http_client.dart';
import '../data_sources/remote/push_notification_data_source.dart';
import '../repositories/push_notification_repository.dart';
import '../repositories/todo_list_repository.dart';

class TodoappWithDependencies extends StatelessWidget {
  const TodoappWithDependencies({
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
            final client = ApiHttpClient()..options.baseUrl = config.baseUrl;
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

  List<SingleChildWidget> get _libs => [
        ...TranslationsDependencies.from(baseUrl: config.baseUrl).providers,
      ];

  List<Provider> get _dataSources => [
        Provider<PushNotificationsDataSource>(
          create: (context) => PushNotificationsDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),
        Provider<PermissionsRemoteDataSource>(
          create: (context) => PermissionsRemoteDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),
        Provider<ProfileLocalDataSource>(
          create: (context) =>
              ProfileLocalDataSource(context.read<SharedPreferencesInstance>()),
        ),
        Provider<TodoListDataSource>(
          create: (context) =>
              TodoListDataSource(context.read<SharedPreferencesInstance>()),
        ),
      ];

  List<Provider> get _repositories => [
        Provider<PushNotificationRepository>(
          create: (context) => PushNotificationRepository(
            context.read(),
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
        Provider<PermissionsRepository>(
          create: (context) => PermissionsRepository(
            context.read(),
            context.read(),
          ),
        ),
        Provider<TodoListRepository>(
          create: (context) => TodoListRepository(
            context.read(),
            context.read(),
          ),
        ),
      ];

  List<Provider> get _services => [
        Provider<PermissionsService>(
          create: (context) => PermissionsService(
            context.read(),
          ),
        ),
        Provider<SplashService>(
          create: (context) => SplashService(
            context.read(),
            context.read(),
          ),
        ),
        Provider<PushNotificationsService>(
          create: (context) => PushNotificationsService(
            context.read(),
          ),
        ),
        Provider<TodoListService>(
          create: (context) => TodoListService(
            context.read(),
          ),
        ),
        Provider<TodoActionsService>(
          create: (context) => TodoActionsService(context.read()),
        )
      ];

  List<SingleChildWidget> get _blocs => [
        Provider<RouterBlocType>(
          create: (context) => RouterBloc(
            router: context.read<AppRouter>().router,
            permissionsService: context.read(),
          ),
        ),
        Provider<TodoActionsBlocType>(
          create: (context) => TodoActionsBloc(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
        RxBlocProvider<PushNotificationsBlocType>(
          create: (context) => PushNotificationsBloc(
            context.read(),
          ),
        ),
      ];
}
