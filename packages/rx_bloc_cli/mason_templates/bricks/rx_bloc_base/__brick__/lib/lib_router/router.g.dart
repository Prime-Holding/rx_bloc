// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<GoRoute> get $appRoutes => [
      $splashRoute,
      $counterRoute,
    ];

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
}

GoRoute get $counterRoute => GoRouteData.$route(
      path: '/',
      factory: $CounterRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'notifications',
          factory: $NotificationsRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'login',
          factory: $LoginRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'enterMessage',
          factory: $EnterMessageRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'items',
          factory: $ItemsRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: ':id',
              factory: $ItemDetailsRouteExtension._fromState,
            ),
          ],
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

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  String get location => GoRouteData.$location(
        '/login',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $EnterMessageRouteExtension on EnterMessageRoute {
  static EnterMessageRoute _fromState(GoRouterState state) =>
      const EnterMessageRoute();

  String get location => GoRouteData.$location(
        '/enterMessage',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $ItemsRouteExtension on ItemsRoute {
  static ItemsRoute _fromState(GoRouterState state) => const ItemsRoute();

  String get location => GoRouteData.$location(
        '/items',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $ItemDetailsRouteExtension on ItemDetailsRoute {
  static ItemDetailsRoute _fromState(GoRouterState state) => ItemDetailsRoute(
        state.params['id']!,
      );

  String get location => GoRouteData.$location(
        '/items/${Uri.encodeComponent(id)}',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}
