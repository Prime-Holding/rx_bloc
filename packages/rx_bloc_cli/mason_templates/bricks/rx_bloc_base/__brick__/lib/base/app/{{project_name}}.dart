{{> licence.dart }}
{{#enable_change_language}}
import 'dart:async'; {{/enable_change_language}}
{{#push_notifications}}
import 'package:firebase_messaging/firebase_messaging.dart';{{/push_notifications}}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';{{#enable_pin_code}}
import 'package:local_session_timeout/local_session_timeout.dart';{{/enable_pin_code}}
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart'; {{#enable_change_language}}
import 'package:widget_toolkit/language_picker.dart'; {{/enable_change_language}}

import '../../assets.dart';{{#enable_remote_translations}}
import '../../l10n/{{project_name}}_app_i18n.dart';{{/enable_remote_translations}}{{#analytics}}
import '../../lib_analytics/blocs/analytics_bloc.dart';{{/analytics}}{{#has_authentication}}{{#enable_pin_code}}
import '../../lib_auth/blocs/user_account_bloc.dart';{{/enable_pin_code}}
import '../../lib_auth/data_sources/remote/interceptors/auth_interceptor.dart';{{/has_authentication}} {{#enable_change_language}}
import '../../lib_change_language/bloc/change_language_bloc.dart';{{/enable_change_language}}{{#enable_dev_menu}}
import '../../lib_dev_menu/ui_components/app_dev_menu_gesture_detector_with_dependencies.dart';{{/enable_dev_menu}}
import '../../lib_router/router.dart';
import '../data_sources/remote/http_clients/api_http_client.dart';
import '../data_sources/remote/http_clients/plain_http_client.dart';{{#analytics}}
import '../data_sources/remote/interceptors/analytics_interceptor.dart';{{/analytics}}
import '../di/{{project_name}}_with_dependencies.dart';{{#has_authentication}}
import '../models/user_model.dart';{{/has_authentication}}
import '../theme/design_system.dart';
import '../theme/{{project_name}}_theme.dart';{{#enable_dev_menu}}
import '../utils/dev_menu.dart';{{/enable_dev_menu}}
import '../utils/helpers.dart';
import 'config/app_constants.dart';
import 'config/environment_config.dart';{{#push_notifications}}
import 'initialization/firebase_messaging_callbacks.dart';{{/push_notifications}}

/// This widget is the root of your application.
class {{project_name.pascalCase()}} extends StatelessWidget {
  const {{project_name.pascalCase()}}({
    this.config = EnvironmentConfig.production,
{{#enable_dev_menu}}
    this.createDevMenuInstance,{{/enable_dev_menu}}
    super.key,
  });

  final EnvironmentConfig config;
{{#enable_dev_menu}}
  final CreateDevMenuInstance? createDevMenuInstance;
{{/enable_dev_menu}}
@override
  Widget build(BuildContext context) => {{project_name.pascalCase()}}WithDependencies(
        config: config,
{{#enable_dev_menu}}

        child: _MyMaterialApp(config, createDevMenuInstance),{{/enable_dev_menu}}
{{^enable_dev_menu}} child: const _MyMaterialApp(),{{/enable_dev_menu}}
      );
}

/// Wrapper around the MaterialApp widget to provide additional functionality
/// accessible throughout the app (such as App-level dependencies, Firebase
/// services, etc).
class _MyMaterialApp extends StatefulWidget {
{{^enable_dev_menu}} const _MyMaterialApp(); {{/enable_dev_menu}}
{{#enable_dev_menu}} const _MyMaterialApp(
    this.config,
    this.createDevMenuInstance,
); {{/enable_dev_menu}}
{{#enable_dev_menu}}
  final EnvironmentConfig config;
  final CreateDevMenuInstance? createDevMenuInstance;
{{/enable_dev_menu}}
  @override
  __MyMaterialAppState createState() => __MyMaterialAppState();
}

class __MyMaterialAppState extends State<_MyMaterialApp> {
  Locale? _locale;
  {{#enable_change_language}}
  late StreamSubscription<LanguageModel> _languageSubscription; {{/enable_change_language}}{{#enable_pin_code}}
  late SessionConfig _sessionConfig;{{/enable_pin_code}}
  {{#analytics}}
  // ignore: unused_field
  late AnalyticsBlocType _analyticsBloc;
  {{/analytics}}

  @override
  void initState() {
    {{^enable_change_language}}
    _locale = const Locale('en'); {{/enable_change_language}}{{#enable_pin_code}}
    _createSessionConfig();{{/enable_pin_code}}
    {{#enable_change_language}}
    _updateLocale(); {{/enable_change_language}} {{#push_notifications}}
    _configureFCM(); {{/push_notifications}}
    {{#analytics}}
    _configureAnalyticsAndCrashlytics();
    {{/analytics}}
    _configureInterceptors();
    super.initState();
  }

  {{#enable_pin_code}}
  void _createSessionConfig() {
    _sessionConfig = SessionConfig(
        invalidateSessionForAppLostFocus: const Duration(seconds: 15),
        invalidateSessionForUserInactivity: const Duration(minutes: 5),
    );
    _userInactivityListeners();
  }

  void _userInactivityListeners() {
  _sessionConfig.stream
        .withLatestFrom(context.read<UserAccountBlocType>().states.currentUser,
            (timeout, user) => (user: user, timeout: timeout))
        .listen((value) {
      if (_shouldNavigateToVerifyPinCode(value) && mounted) {
        final AppRouter appRouter = context.read<AppRouter>();
        final GoRouter router = appRouter.router;
        final String verifyPinRoute = const VerifyPinCodeRoute().routeLocation;

        if (!router.routeInformationProvider.value.uri
            .toString()
            .contains(verifyPinRoute)) {
          router.push(
            verifyPinRoute,
          );
        }
      }
    });
  }
  
  bool _shouldNavigateToVerifyPinCode(
      ({SessionTimeoutState timeout, UserModel? user}) value) {
    return (value.timeout == SessionTimeoutState.userInactivityTimeout ||
            value.timeout == SessionTimeoutState.appFocusTimeout) &&
        value.user?.hasPin == true;
  }{{/enable_pin_code}}

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
    await onInitialMessageOpened(initialMessage);

    FirebaseMessaging.instance.onTokenRefresh
        .listen((token) => onFCMTokenRefresh(token));

    FirebaseMessaging.onMessage.listen((message) {
      if(mounted) {
        onForegroundMessage(context, message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if(mounted) {
        onMessageOpenedFromBackground(context, message);
      }
    });
  }{{/push_notifications}}{{#analytics}}

  void _configureAnalyticsAndCrashlytics() {
    // Currently we only need to have a reference to an analytics bloc instance
    // since it's not exposing any events or states and all operations
    // are performed through its internal subscriptions.
    _analyticsBloc = context.read();
  }
  {{/analytics}}

  void _configureInterceptors() {
    context.read<PlainHttpClient>().configureInterceptors({{#analytics}}
          AnalyticsInterceptor(context.read()),{{/analytics}}
    );

    context.read<ApiHttpClient>().configureInterceptors({{#has_authentication}}
          AuthInterceptor(
            context.read(),
            context.read(),
            context.read(),
          ),{{/has_authentication}}{{#analytics}}
          AnalyticsInterceptor(context.read()),{{/analytics}}
        );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final materialApp =
    {{^enable_pin_code}} _buildMaterialApp(context);{{/enable_pin_code}}
    {{#enable_pin_code}} _buildMaterialAppWithPinCode(); {{/enable_pin_code}}

      {{#enable_dev_menu}}
      if (EnvironmentConfig.enableDevMenu) {
        return AppDevMenuGestureDetectorWithDependencies(
          navigatorKey: AppRouter.rootNavigatorKey,
          child: materialApp,
        );
      }{{/enable_dev_menu}}

      return materialApp;
  }
{{#enable_pin_code}}
    Widget _buildMaterialAppWithPinCode() => SessionTimeoutManager(
      userActivityDebounceDuration: const Duration(seconds: 2),
      sessionConfig: _sessionConfig,
      child: _buildMaterialApp(context));{{/enable_pin_code}}

Widget _buildMaterialApp(BuildContext context) => MaterialApp.router(
       title: '{{#titleCase}}{{project_name}}{{/titleCase}}',
       theme: {{project_name.pascalCase()}}Theme.buildTheme(DesignSystem.light()),
       darkTheme: {{project_name.pascalCase()}}Theme.buildTheme(DesignSystem.dark()),
       localizationsDelegates: const [ {{#enable_remote_translations}}
         AppI18n.delegate,{{/enable_remote_translations}}{{^enable_remote_translations}}
         I18n.delegate,{{/enable_remote_translations}}
         ...GlobalMaterialLocalizations.delegates,
       ],
       supportedLocales: I18n.supportedLocales,
       locale: _locale,
       routerConfig: context.read<AppRouter>().router,
       debugShowCheckedModeBanner: false,
     );

}
