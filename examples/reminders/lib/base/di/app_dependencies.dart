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
import '../app/config/environment_config.dart';
import '../common_blocs/coordinator_bloc.dart';
import '../common_blocs/firebase_bloc.dart';
import '../data_sources/remote/interceptors/analytics_interceptor.dart';
import '../data_sources/remote/reminders_firebase_data_source.dart';
import '../repositories/firebase_repository.dart';
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
        ..._blocs,
        ..._interceptors,
      ];

  List<Provider> get _analytics => [
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
        Provider<FlutterSecureStorage>(
            create: (context) => const FlutterSecureStorage()),
      ];

  /// Use different data source regarding of if it is running in web ot not
  List<Provider> get _dataSources => [
        Provider<RemindersFirebaseDataSource>(
          create: (context) => RemindersFirebaseDataSource(),
        ),
      ];

  List<Provider> get _repositories => [
        Provider<RemindersRepository>(
          create: (context) => RemindersRepository(
            dataSource: RemindersFirebaseDataSource(),
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
