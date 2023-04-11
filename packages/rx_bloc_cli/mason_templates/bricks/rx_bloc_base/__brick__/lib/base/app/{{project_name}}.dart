{{> licence.dart }}
{{#enable_change_language}}
import 'dart:async'; {{/enable_change_language}}
{{#analytics}}
import 'package:firebase_analytics/firebase_analytics.dart';{{/analytics}}{{#push_notifications}}
import 'package:firebase_messaging/firebase_messaging.dart';{{/push_notifications}}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart'; {{#enable_change_language}}
import 'package:widget_toolkit/language_picker.dart'; {{/enable_change_language}}
import '../../l10n/l10n.dart';
import '../../lib_auth/data_sources/remote/interceptors/auth_interceptor.dart'; {{#enable_change_language}}
import '../../lib_change_language/bloc/change_language_bloc.dart';{{/enable_change_language}}
import '../../lib_router/router.dart';
import '../data_sources/remote/http_clients/api_http_client.dart';
import '../data_sources/remote/http_clients/plain_http_client.dart';{{#analytics}}
import '../data_sources/remote/interceptors/analytics_interceptor.dart';{{/analytics}}
import '../di/{{project_name}}_with_dependencies.dart';
import '../theme/design_system.dart';
import '../theme/{{project_name}}_theme.dart';
import '../utils/helpers.dart';
import 'config/app_constants.dart';
import 'config/environment_config.dart';{{#push_notifications}}
import 'initialization/firebase_messaging_callbacks.dart';{{/push_notifications}}

/// This widget is the root of your application.
class {{project_name.pascalCase()}} extends StatelessWidget {
  const {{project_name.pascalCase()}}({
    this.config = const EnvironmentConfig.production(),
    Key? key,
  }) : super(key: key);

  final EnvironmentConfig config;

  @override
  Widget build(BuildContext context) => {{project_name.pascalCase()}}WithDependencies(
        config: config,
        child: const _MyMaterialApp(),
      );
}

/// Wrapper around the MaterialApp widget to provide additional functionality
/// accessible throughout the app (such as App-level dependencies, Firebase
/// services, etc).
class _MyMaterialApp extends StatefulWidget {
  const _MyMaterialApp();

  @override
  __MyMaterialAppState createState() => __MyMaterialAppState();
}

class __MyMaterialAppState extends State<_MyMaterialApp> {
  Locale? _locale;
  {{#enable_change_language}}
  late StreamSubscription<LanguageModel> _languageSubscription; {{/enable_change_language}}

  @override
  void initState() {
    {{^enable_change_language}}
    _locale = const Locale('en'); {{/enable_change_language}}
    {{#enable_change_language}}
    _updateLocale(); {{/enable_change_language}} {{#push_notifications}}
    _configureFCM(); {{/push_notifications}}
    _configureInterceptors();
    super.initState();
  }

  {{#enable_change_language}}
  void _updateLocale() {
    _languageSubscription = context
        .read<ChangeLanguageBlocType>()
        .states
        .currentLanguage
        .listen((language) {
      setState(
        () => _locale = Locale(language.locale),
      );
    });
  } {{/enable_change_language}}

  {{#enable_change_language}}
  @override
  void dispose() {
    _languageSubscription.cancel();
    super.dispose();
  } {{/enable_change_language}}

  {{#push_notifications}}
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

  void _configureInterceptors() {
    context.read<PlainHttpClient>().configureInterceptors({{#analytics}}
          AnalyticsInterceptor(context.read()),{{/analytics}}
    );

    context.read<ApiHttpClient>().configureInterceptors(
          AuthInterceptor(
            context.read(),
            context.read(),
            context.read(),
          ),{{#analytics}}
          AnalyticsInterceptor(context.read()),{{/analytics}}
        );
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: '{{#titleCase}}{{project_name}}{{/titleCase}}',
        theme: {{project_name.pascalCase()}}Theme.buildTheme(DesignSystem.light()),
        darkTheme: {{project_name.pascalCase()}}Theme.buildTheme(DesignSystem.dark()),
        localizationsDelegates: const [
          I18n.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: I18n.supportedLocales,
        locale: _locale,
        routerConfig: context.read<AppRouter>().router,
        debugShowCheckedModeBanner: false,
      );
}
