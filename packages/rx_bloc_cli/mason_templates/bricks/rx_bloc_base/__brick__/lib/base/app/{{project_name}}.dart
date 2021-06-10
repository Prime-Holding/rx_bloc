// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

{{#analytics}}
import 'package:firebase_analytics/observer.dart';{{/analytics}}{{#push_notifications}}
import 'package:firebase_messaging/firebase_messaging.dart';{{/push_notifications}}
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../../l10n/l10n.dart';
import '../di/app_dependencies.dart';
import '../routers/router.gr.dart' as router;
import '../theme/design_system.dart';
import '../utils/helpers.dart';
import 'config/app_constants.dart';
import 'config/environment_config.dart';{{#push_notifications}}
import 'initialization/firebase_messaging_callbacks.dart';{{/push_notifications}}

/// This widget is the root of your application.
class {{#pascalCase}}{{project_name}}{{/pascalCase}} extends StatelessWidget {
  {{#pascalCase}}{{project_name}}{{/pascalCase}}({this.config = EnvironmentConfig.prod});

  final EnvironmentConfig config;
  final _router = router.Router();

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: AppDependencies.of(context).providers,
        child: _MyMaterialApp(_router),
      );
}

class _MyMaterialApp extends StatefulWidget {
  const _MyMaterialApp(this._router);

  final router.Router _router;

@override
__MyMaterialAppState createState() => __MyMaterialAppState();
}

class __MyMaterialAppState extends State<_MyMaterialApp> {

  @override
  void initState() { {{#push_notifications}}
    _configureWebFCM();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((message) => onInitialMessageOpened(context, message));
    FirebaseMessaging.instance.onTokenRefresh
        .listen((token) => onFCMTokenRefresh(context, token));
    FirebaseMessaging.onMessage
        .listen((message) => onForegroundMessage(context, message));
    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => onMessageOpenedFromBackground(context, message));{{/push_notifications}}

    super.initState();
  }{{#push_notifications}}

  Future<void> _configureWebFCM() async {
    await safeRun(
        () => FirebaseMessaging.instance.getToken(vapidKey: webVapidKey));
  }{{/push_notifications}}

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: '{{#titleCase}}{{project_name}}{{/titleCase}}',
        theme: DesignSystem.fromBrightness(Brightness.light).theme,
        darkTheme: DesignSystem.fromBrightness(Brightness.dark).theme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routeInformationParser: widget._router.defaultRouteParser(),
        routerDelegate: widget._router.delegate({{#analytics}}
          navigatorObservers: () => [
            context.read<FirebaseAnalyticsObserver>(),
          ],
        {{/analytics}}),
        debugShowCheckedModeBanner: false,
      );
}
