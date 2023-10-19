{{> licence.dart }}
{{#enable_change_language}}
import 'dart:async'; {{/enable_change_language}}
{{#push_notifications}}
import 'package:firebase_messaging/firebase_messaging.dart';{{/push_notifications}}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';{{#enable_pin_code}}
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:local_session_timeout/local_session_timeout.dart';{{/enable_pin_code}}
import 'package:provider/provider.dart'; {{#enable_change_language}}
import 'package:widget_toolkit/language_picker.dart'; {{/enable_change_language}}

import '../../assets.dart';{{#analytics}}
import '../../l10n/{{project_name}}_app_i18n.dart';
import '../../lib_analytics/blocs/analytics_bloc.dart';{{/analytics}}{{#has_authentication}}{{#enable_pin_code}}
import '../../lib_auth/blocs/user_account_bloc.dart';{{/enable_pin_code}}
import '../../lib_auth/data_sources/remote/interceptors/auth_interceptor.dart';{{/has_authentication}} {{#enable_change_language}}
import '../../lib_change_language/bloc/change_language_bloc.dart';{{/enable_change_language}}{{#enable_dev_menu}}
import '../../lib_dev_menu/ui_components/app_dev_menu.dart';{{/enable_dev_menu}}{{#enable_pin_code}}
import '../../lib_pin_code/bloc/create_pin_bloc.dart';
import '../../lib_pin_code/bloc/update_and_verify_pin_bloc.dart';
import '../../lib_pin_code/models/pin_code_arguments.dart';
import '../../lib_router/blocs/router_bloc.dart';{{/enable_pin_code}}
import '../../lib_router/router.dart';
import '../data_sources/remote/http_clients/api_http_client.dart';
import '../data_sources/remote/http_clients/plain_http_client.dart';{{#analytics}}
import '../data_sources/remote/interceptors/analytics_interceptor.dart';{{/analytics}}
import '../di/{{project_name}}_with_dependencies.dart';
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
  Key? key,
  }) : super(key: key);

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
    context.read<UpdateAndVerifyPinBlocType>().events.deleteSavedData();
    _sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(seconds: 60),
      invalidateSessionForUserInactivity: const Duration(seconds: 7),
    );
    context
        .read<UpdateAndVerifyPinBlocType>()
        .events
        .setSessionState(SessionState.startListening);
    _userInactivityListeners();
  }

  void _userInactivityListeners() {
    _sessionConfig.stream.listen((timeoutEvent) {
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout ||
          timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        context.read<RouterBlocType>().events.go(
              const VerifyPinCodeRoute(),
              extra: const PinCodeArguments(
                  title: 'Enter Pin Code', isSessionTimeout: true),
            );
      }
    });
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
    if (!mounted) return;
    await onInitialMessageOpened(context, initialMessage);

    FirebaseMessaging.instance.onTokenRefresh
        .listen((token) => onFCMTokenRefresh(context, token));
    FirebaseMessaging.onMessage
        .listen((message) => onForegroundMessage(context, message));
    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => onMessageOpenedFromBackground(context, message));
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
    final materialApp = 
    {{^enable_pin_code}} _buildMaterialApp(context);{{/enable_pin_code}}
    {{#enable_pin_code}} _buildMaterialAppWithPinCode(); {{/enable_pin_code}}

      {{#enable_dev_menu}}
      if (EnvironmentConfig.enableDevMenu) {
        return AppDevMenuGestureDetector.withDependencies(
          context,
          AppRouter.rootNavigatorKey,
          child: materialApp,
        );
      }{{/enable_dev_menu}}

      return materialApp;
  }
{{#enable_pin_code}}
  Widget _buildMaterialAppWithPinCode() =>
      RxBlocBuilder<CreatePinBlocType, bool>(
         state: (bloc) => bloc.states.isPinCreated,
         builder: (context, isPinCreated, bloc) =>
             RxBlocBuilder<UserAccountBlocType, bool>(
           state: (bloc) => bloc.states.loggedIn,
           builder: (context, loggedIn, bloc) {
             if (loggedIn.hasData) {
               if (!loggedIn.data!) {
                 // If user logs out, set stopListening
                 context.read<UpdateAndVerifyPinBlocType>()
                        .events
                        .setSessionState(SessionState.stopListening);
                 return _buildMaterialApp(context);
               }
               if ((loggedIn.data!) &&
                   (isPinCreated.hasData && isPinCreated.data!)) {
                 context
                     .read<UpdateAndVerifyPinBlocType>()
                     .events
                     .setSessionState(SessionState.startListening);

                 return SessionTimeoutManager(
                     userActivityDebounceDuration: const Duration(seconds: 2),
                     sessionConfig: _sessionConfig,
                     sessionStateStream: context
                         .read<UpdateAndVerifyPinBlocType>()
                         .states
                         .sessionValue,
                     child: _buildMaterialApp(context));
               }
             }
             return _buildMaterialApp(context);
           },
         ),
       );{{/enable_pin_code}}

Widget _buildMaterialApp(BuildContext context) => MaterialApp.router(
       title: '{{#titleCase}}{{project_name}}{{/titleCase}}',
       theme: {{project_name.pascalCase()}}Theme.buildTheme(DesignSystem.light()),
       darkTheme: {{project_name.pascalCase()}}Theme.buildTheme(DesignSystem.dark()),
       localizationsDelegates: const [
         AppI18n.delegate,
         ...GlobalMaterialLocalizations.delegates,
       ],
       supportedLocales: I18n.supportedLocales,
       locale: _locale,
       routerConfig: context.read<AppRouter>().router,
       debugShowCheckedModeBanner: false,
     );

}
