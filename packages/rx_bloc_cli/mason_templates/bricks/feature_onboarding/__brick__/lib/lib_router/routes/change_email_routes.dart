part of '../router.dart';

@TypedGoRoute<ConfirmEmailRoute>(path: RoutesPath.emailChangeConfirm)
@immutable
class ConfirmEmailRoute extends GoRouteData implements RouteDataModel {
  const ConfirmEmailRoute(this._email);
  final String _email;

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: ChangeEmailConfirmationPageWithDependencies(email: _email),
      );

  @override
  String get permissionName => RouteModel.emailChangeConfirm.permissionName;

  @override
  String get routeLocation => location;
}

@TypedGoRoute<ConfirmedEmailRoute>(path: RoutesPath.emailChangeConfirmed)
@immutable
class ConfirmedEmailRoute extends GoRouteData implements RouteDataModel {
  const ConfirmedEmailRoute(this.token);

  final String token;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: ChangeEmailConfirmedPageWithDependencies(
          verifyEmailToken: token,
          isOnboarding: false,
        ),
      );

  @override
  String get permissionName => RouteModel.emailChangeConfirmed.permissionName;

  @override
  String get routeLocation => location;
}

@immutable
class ConfirmChangeEmailRoute extends GoRouteData implements RouteDataModel {
  const ConfirmChangeEmailRoute(this._email);
  final String _email;

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: ChangeEmailConfirmationPageWithDependencies(email: _email),
      );

  @override
  String get permissionName => RouteModel.emailChange.permissionName;

  @override
  String get routeLocation => location;
}
