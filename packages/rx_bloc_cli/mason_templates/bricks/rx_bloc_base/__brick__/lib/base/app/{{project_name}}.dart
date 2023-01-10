{{> licence.dart }}

import 'package:dio/dio.dart';{{#analytics}}
import 'package:firebase_analytics/firebase_analytics.dart';{{/analytics}}{{#push_notifications}}
import 'package:firebase_messaging/firebase_messaging.dart';{{/push_notifications}}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../l10n/l10n.dart';{{#analytics}}
import '../data_sources/remote/interceptors/analytics_interceptor.dart';{{/analytics}}
import '../data_sources/remote/interceptors/auth_interceptor.dart';
import '../di/app_dependencies.dart';
import '../routers/router.dart';
import '../theme/design_system.dart';
import '../theme/{{project_name}}_theme.dart';
import '../utils/helpers.dart';
import 'config/app_constants.dart';
import 'config/environment_config.dart';{{#push_notifications}}
import 'initialization/firebase_messaging_callbacks.dart';{{/push_notifications}}

/// This widget is the root of your application.
class {{project_name.pascalCase()}} extends StatelessWidget {
  {{project_name.pascalCase()}}({
    this.config = const EnvironmentConfig.production(),
    Key? key,
  }) : super(key: key);

  final EnvironmentConfig config;
  final _router = GoRouter(routes: $appRoutes);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: AppDependencies.of(context,config).providers,
        child: _MyMaterialApp(_router),
      );
}

/// Wrapper around the MaterialApp widget to provide additional functionality
/// accessible throughout the app (such as App-level dependencies, Firebase
/// services, etc).
class _MyMaterialApp extends StatefulWidget {
  const _MyMaterialApp(this._router);

  final GoRouter _router;

@override
__MyMaterialAppState createState() => __MyMaterialAppState();
}

class __MyMaterialAppState extends State<_MyMaterialApp> {

  @override
  void initState() { {{#push_notifications}}
    _configureFCM(); {{/push_notifications}}
    _addInterceptors();

    super.initState();
  }{{#push_notifications}}

  Future<void> _configureFCM() async {
    /// Initialize the FCM callbacks
    if (kIsWeb){
        await safeRun(
            () => FirebaseMessaging.instance.getToken(vapidKey: webVapidKey));
    }

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (!mounted) return;
    await onInitialMessageOpened(context, initialMessage);

    FirebaseMessaging.instance.onTokenRefresh
        .listen((token) => onFCMTokenRefresh(context, token));
    FirebaseMessaging.onMessage
        .listen((message) => onForegroundMessage(context, message));
    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => onMessageOpenedFromBackground(context, message));
  }{{/push_notifications}}

  void _addInterceptors() {
    context.read<Dio>().interceptors.addAll([
      context.read<AuthInterceptor>(),{{#analytics}}
      context.read<AnalyticsInterceptor>(),{{/analytics}}
      context.read<LogInterceptor>(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '{{#titleCase}}{{project_name}}{{/titleCase}}',
      theme: {{project_name.pascalCase()}}Theme.buildTheme(DesignSystem.light()),
      darkTheme: {{project_name.pascalCase()}}Theme.buildTheme(DesignSystem.dark()),
      localizationsDelegates: const [
        I18n.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: I18n.supportedLocales,
      routerConfig: widget._router,
      debugShowCheckedModeBanner: false,
    );
  }
}
