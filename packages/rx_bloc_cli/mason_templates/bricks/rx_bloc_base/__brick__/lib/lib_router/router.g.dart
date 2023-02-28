// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<GoRoute> get $appRoutes => [
      $loginRoute,
      $profileRoute,
      $splashRoute,
      $counterRoute,
      $deepLinksRoute,
    ];

GoRoute get $loginRoute => GoRouteData.$route(
      path: '/login',
      factory: $LoginRouteExtension._fromState,
    );

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  String get location => GoRouteData.$location(
        '/login',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: this);
}

GoRoute get $profileRoute => GoRouteData.$route(
      path: '/profile',
      factory: $ProfileRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'notifications',
          factory: $NotificationsRouteExtension._fromState,
        ),
      ],
    );

extension $ProfileRouteExtension on ProfileRoute {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  String get location => GoRouteData.$location(
        '/profile',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: this);
}

extension $NotificationsRouteExtension on NotificationsRoute {
  static NotificationsRoute _fromState(GoRouterState state) =>
      const NotificationsRoute();

  String get location => GoRouteData.$location(
        '/profile/notifications',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: this);
}

GoRoute get $splashRoute => GoRouteData.$route(
      path: '/splash',
      factory: $SplashRouteExtension._fromState,
    );

extension $SplashRouteExtension on SplashRoute {
  static SplashRoute _fromState(GoRouterState state) => const SplashRoute();

  String get location => GoRouteData.$location(
        '/splash',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: this);
}

GoRoute get $counterRoute => GoRouteData.$route(
      path: '/counter',
      factory: $CounterRouteExtension._fromState,
    );

extension $CounterRouteExtension on CounterRoute {
  static CounterRoute _fromState(GoRouterState state) => const CounterRoute();

  String get location => GoRouteData.$location(
        '/counter',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: this);
}

GoRoute get $deepLinksRoute => GoRouteData.$route(
      path: '/deepLinks',
      factory: $DeepLinksRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: ':id',
          factory: $DeepLinkDetailsRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'enterMessage',
          factory: $EnterMessageRouteExtension._fromState,
        ),
      ],
    );

extension $DeepLinksRouteExtension on DeepLinksRoute {
  static DeepLinksRoute _fromState(GoRouterState state) =>
      const DeepLinksRoute();

  String get location => GoRouteData.$location(
        '/deepLinks',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: this);
}

extension $DeepLinkDetailsRouteExtension on DeepLinkDetailsRoute {
  static DeepLinkDetailsRoute _fromState(GoRouterState state) =>
      DeepLinkDetailsRoute(
        state.params['id']!,
      );

  String get location => GoRouteData.$location(
        '/deepLinks/${Uri.encodeComponent(id)}',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: this);
}

extension $EnterMessageRouteExtension on EnterMessageRoute {
  static EnterMessageRoute _fromState(GoRouterState state) =>
      const EnterMessageRoute();

  String get location => GoRouteData.$location(
        '/deepLinks/enterMessage',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: this);
}
