// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../../l10n/l10n.dart';
import '../data_sources/remote/interceptors/analytics_interceptor.dart';
import '../data_sources/remote/interceptors/auth_interceptor.dart';
import '../di/app_dependencies.dart';
import '../routers/router.gr.dart' as router;
import '../theme/design_system.dart';
import '../utils/helpers.dart';
import 'config/app_constants.dart';
import 'config/environment_config.dart';
import 'initialization/firebase_messaging_callbacks.dart';

/// This widget is the root of your application.
class GithubSearch extends StatelessWidget {
  GithubSearch({this.config = EnvironmentConfig.prod});

  final EnvironmentConfig config;
  final _router = router.Router();

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: AppDependencies.of(context, config).providers,
        child: _MyMaterialApp(_router),
      );
}

/// Wrapper around the MaterialApp widget to provide additional functionality
/// accessible throughout the app (such as App-level dependencies, Firebase
/// services, etc).
class _MyMaterialApp extends StatefulWidget {
  const _MyMaterialApp(this._router);

  final router.Router _router;

  @override
  __MyMaterialAppState createState() => __MyMaterialAppState();
}

class __MyMaterialAppState extends State<_MyMaterialApp> {
  @override
  void initState() {
    _configureFCM();
    _addInterceptors();

    super.initState();
  }

  Future<void> _configureFCM() async {
    /// Initialize the FCM callbacks
    if (kIsWeb) {
      await safeRun(
          () => FirebaseMessaging.instance.getToken(vapidKey: webVapidKey));
    }
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((message) => onInitialMessageOpened(context, message));
    FirebaseMessaging.instance.onTokenRefresh
        .listen((token) => onFCMTokenRefresh(context, token));
    FirebaseMessaging.onMessage
        .listen((message) => onForegroundMessage(context, message));
    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => onMessageOpenedFromBackground(context, message));
  }

  void _addInterceptors() {
    // context.read<Dio>().interceptors.addAll([
    //   AuthInterceptor(context.read(), context.read(), context.read()),
    //   AnalyticsInterceptor(context.read()),
    //
    //   /// TODO: Add your own interceptors here
    // ]);
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Github Search',
        theme: DesignSystem.fromBrightness(Brightness.light).theme,
        darkTheme: DesignSystem.fromBrightness(Brightness.dark).theme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routeInformationParser: widget._router.defaultRouteParser(),
        routerDelegate: widget._router.delegate(
          navigatorObservers: () => [
            context.read<FirebaseAnalyticsObserver>(),
          ],
        ),
        debugShowCheckedModeBanner: false,
      );
}
