// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../l10n/l10n.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../common_blocs/coordinator_bloc.dart';
import '../data_sources/remote/interceptors/analytics_interceptor.dart';
import '../di/app_dependencies.dart';
import '../theme/design_system.dart';
import 'config/environment_config.dart';

/// This widget is the root of your application.
class Reminders extends StatelessWidget {
  const Reminders({
    this.config = EnvironmentConfig.production,
    Key? key,
  }) : super(key: key);

  final EnvironmentConfig config;

  @override
  Widget build(BuildContext context) =>
      AppDependencies.of(context, config, _MyMaterialApp(config));
}

/// Wrapper around the MaterialApp widget to provide additional functionality
/// accessible throughout the app (such as App-level dependencies, Firebase
/// services, etc).
class _MyMaterialApp extends StatefulWidget {
  const _MyMaterialApp(this._config);

  final EnvironmentConfig _config;

  @override
  __MyMaterialAppState createState() => __MyMaterialAppState();
}

class __MyMaterialAppState extends State<_MyMaterialApp> {
  late GoRouter goRouter;

  @override
  void initState() {
    if (widget._config != EnvironmentConfig.development) {
      _addInterceptors();
    }
    final rootNavigatorKey = GlobalKey<NavigatorState>();
    final shellNavigatorKey = GlobalKey<NavigatorState>();
    goRouter = AppRouter(context.read<CoordinatorBlocType>(), rootNavigatorKey,
            shellNavigatorKey)
        .router;

    super.initState();
  }

  void _addInterceptors() {
    context.read<Dio>().interceptors.addAll([
      AnalyticsInterceptor(context.read()),

      /// TODO: Add your own interceptors here
    ]);
  }

  @override
  Widget build(BuildContext context) => Provider<RouterBlocType>(
        create: (context) => RouterBloc(
          router: goRouter,
        ),
        child: MaterialApp.router(
          title: 'Reminders',
          theme: DesignSystem.fromBrightness(Brightness.light).theme,
          darkTheme: DesignSystem.fromBrightness(Brightness.dark).theme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: goRouter,
          debugShowCheckedModeBanner: false,
        ),
      );
}
