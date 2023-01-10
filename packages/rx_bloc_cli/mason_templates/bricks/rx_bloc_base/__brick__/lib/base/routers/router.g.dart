// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<GoRoute> get $appRoutes => [
  $counterRoute,
  $loginRoute,
];

GoRoute get $counterRoute => GoRouteData.$route(
  path: '/',
  factory: $CounterRouteExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: 'notifications',
      factory: $NotificationsRouteExtension._fromState,
    ),
  ],
);

extension $CounterRouteExtension on CounterRoute {
  static CounterRoute _fromState(GoRouterState state) => const CounterRoute();

  String get location => GoRouteData.$location(
    '/',
  );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $NotificationsRouteExtension on NotificationsRoute {
  static NotificationsRoute _fromState(GoRouterState state) =>
      const NotificationsRoute();

  String get location => GoRouteData.$location(
    '/notifications',
  );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

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
}
