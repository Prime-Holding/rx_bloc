// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:realm/realm.dart';

import '../../feature_splash/services/splash_service.dart';
import '../../lib_permissions/data_sources/local/permissions_local_data_source.dart';
import '../../lib_permissions/data_sources/remote/permissions_remote_data_source.dart';
import '../../lib_permissions/models/permission_map_model.dart';
import '../../lib_permissions/models/permission_model.dart';
import '../../lib_permissions/repositories/permissions_repository.dart';
import '../../lib_permissions/services/permissions_service.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../../lib_todo_actions/blocs/todo_actions_bloc.dart';
import '../../lib_todo_actions/blocs/todo_list_bulk_edit_bloc.dart';
import '../../lib_todo_actions/services/todo_actions_service.dart';
import '../../lib_translations/di/translations_dependencies.dart';
import '../app/config/environment_config.dart';
import '../common_blocs/coordinator_bloc.dart';
import '../common_mappers/error_mappers/error_mapper.dart';
import '../common_services/todo_list_service.dart';
import '../data_sources/local/connectivity_data_source.dart';
import '../data_sources/local/shared_preferences_instance.dart';
import '../data_sources/local/todo_local_data_source.dart';
import '../data_sources/remote/http_clients/api_http_client.dart';
import '../data_sources/remote/http_clients/plain_http_client.dart';
import '../data_sources/remote/todos_remote_data_source.dart';
import '../models/todo_model.dart';
import '../repositories/connectivity_repository.dart';
import '../repositories/todo_repository.dart';

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
        Provider<Realm>(
          create: (context) => Realm(Configuration.local([
            TodoModel.schema,
            PermissionMap.schema,
            PermissionModel.schema,
          ])),
        ),
      ];

  List<SingleChildWidget> get _libs => [
        ...TranslationsDependencies.from(baseUrl: config.baseUrl).providers,
      ];

  List<SingleChildWidget> get _dataSources => [
        Provider<ConnectivityDataSource>(
          create: (context) => ConnectivityDataSource(),
        ),
        Provider<TodoLocalDataSource>(
          create: (context) => TodoLocalDataSource(
            context.read(),
          ),
        ),
        Provider<TodosRemoteDataSource>(
          create: (context) => TodosRemoteDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),
        Provider<PermissionsRemoteDataSource>(
          create: (context) => PermissionsRemoteDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),
        Provider<PermissionsLocalDataSource>(
          create: (context) => PermissionsLocalDataSource(
            realmInstance: context.read(),
          ),
        ),
        Provider<ConnectivityDataSource>(
          create: (context) => ConnectivityDataSource(),
        ),
      ];

  List<Provider> get _repositories => [
        Provider<PermissionsRepository>(
          create: (context) => PermissionsRepository(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
        Provider<TodoRepository>(
          create: (context) => TodoRepository(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
        Provider<ConnectivityRepository>(
          create: (context) => ConnectivityRepository(
            context.read(),
            context.read(),
          ),
        ),
      ];

  List<SingleChildWidget> get _services => [
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
        Provider<TodoListService>(
          create: (context) => TodoListService(
            context.read(),
            context.read(),
          ),
          dispose: (context, value) => value.dispose(),
        ),
        Provider<TodoActionsService>(
          create: (context) => TodoActionsService(
            context.read(),
          ),
        ),
      ];

  List<SingleChildWidget> get _blocs => [
        Provider<RouterBlocType>(
          create: (context) => RouterBloc(
            router: context.read<AppRouter>().router,
            permissionsService: context.read(),
          ),
        ),
        RxBlocProvider<TodoListBulkEditBlocType>(
          create: (context) => TodoListBulkEditBloc(
            context.read(),
            context.read(),
          ),
        ),
        Provider<TodoActionsBlocType>(
          create: (context) => TodoActionsBloc(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];
}
