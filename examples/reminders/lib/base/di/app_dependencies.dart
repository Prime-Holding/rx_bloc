// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../feature_reminder_manage/blocs/reminder_manage_bloc.dart';
import '../../lib_router/router.dart';
import '../app/config/environment_config.dart';
import '../common_blocs/coordinator_bloc.dart';
import '../common_blocs/firebase_bloc.dart';
import '../data_sources/remote/api_http_client.dart';
import '../data_sources/remote/interceptors/analytics_interceptor.dart';
import '../data_sources/remote/reminders_firebase_data_source.dart';
import '../data_sources/remote/reminders_rest_data_source.dart';
import '../repositories/firebase_repository.dart';
import '../repositories/reminders_repository.dart';
import '../services/firebase_service.dart';
import '../services/reminders_service.dart';

/// Global dependencies used throughout the app
class AppDependencies extends StatefulWidget {
  const AppDependencies._(this.context, this.config, this.child);

  /// Factory constructor facilitating the retrieval of the [AppDependencies]
  /// instance. If the singleton instance doesn't exist, one is created first.
  factory AppDependencies.of(
          BuildContext context, EnvironmentConfig envConfig, Widget child) =>
      _instance != null
          ? _instance!
          : _instance = AppDependencies._(context, envConfig, child);

  static AppDependencies? _instance;

  final BuildContext context;
  final EnvironmentConfig config;
  final Widget child;
  @override
  State<AppDependencies> createState() => _AppDependenciesState();
}

class _AppDependenciesState extends State<AppDependencies> {
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
          ..._analytics,
          ..._appRouter,
          ..._httpClients,
          ..._dataStorages,
          ..._dataSources,
          ..._repositories,
          ..._services,
          ..._blocs,
          ..._interceptors,
        ],
        child: widget.child,
      );

  List<Provider> get _analytics => [
        Provider<FirebaseAnalytics>(
            create: (context) => FirebaseAnalytics.instance),
        Provider<FirebaseAnalyticsObserver>(
          create: (context) =>
              FirebaseAnalyticsObserver(analytics: context.read()),
        ),
      ];

  List<Provider> get _appRouter => [
        Provider<AppRouter>(
          create: (context) => AppRouter(
            context.read(),
            rootNavigatorKey,
            shellNavigatorKey,
          ),
        )
      ];

  List<Provider> get _httpClients => [
        Provider<Dio>(create: (context) => Dio()),
        Provider<ApiHttpClient>(
          create: (context) {
            final client = ApiHttpClient()
              ..options.baseUrl = widget.config.baseUrl;
            return client;
          },
        ),
      ];

  List<SingleChildWidget> get _dataStorages => [
        Provider<FlutterSecureStorage>(
            create: (context) => const FlutterSecureStorage()),
      ];

  /// Use different data source regarding of if it is running in web ot not
  List<Provider> get _dataSources => [
        Provider<RemindersFirebaseDataSource>(
          create: (context) => RemindersFirebaseDataSource(),
        ),
        Provider<RemindersRestDataSource>(
          create: (context) => RemindersRestDataSource(
            context.read<ApiHttpClient>(),
          ),
        )
      ];

  List<Provider> get _repositories => [
        Provider<RemindersRepository>(
          create: (context) => RemindersRepository(
            dataSource: context.read<RemindersRestDataSource>(),
          ),
        ),
        Provider<FirebaseRepository>(
          create: (context) => FirebaseRepository(
            dataSource: context.read(),
          ),
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
        RxBlocProvider<FirebaseBlocType>(
          create: (context) => FirebaseBloc(
            context.read(),
            context.read(),
          ),
          lazy: false,
        ),
      ];

  List<Provider> get _interceptors => [
        Provider<AnalyticsInterceptor>(
          create: (context) => AnalyticsInterceptor(context.read()),
        ),
      ];
}
