part of '../router.dart';

@TypedGoRoute<PasswordResetRequestRoute>(path: RoutesPath.passwordResetRequest)
@immutable
class PasswordResetRequestRoute extends GoRouteData implements RouteDataModel {
  const PasswordResetRequestRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const PasswordResetRequestPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.passwordResetRequest.permissionName;

  @override
  String get routeLocation => location;
}

@TypedGoRoute<PasswordResetConfirmationRoute>(
    path: RoutesPath.passwordResetConfirmation)
@immutable
class PasswordResetConfirmationRoute extends GoRouteData
    implements RouteDataModel {
  const PasswordResetConfirmationRoute(this._email);

  final String _email;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: PasswordResetConfirmationPageWithDependencies(email: _email),
      );

  @override
  String get permissionName =>
      RouteModel.passwordResetConfirmation.permissionName;

  @override
  String get routeLocation => location;
}

@TypedGoRoute<PasswordResetRoute>(path: RoutesPath.passwordReset)
@immutable
class PasswordResetRoute extends GoRouteData implements RouteDataModel {
  const PasswordResetRoute(this.token, this.email);

  final String token;
  final String email;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: PasswordResetPageWithDependencies(token, email),
      );

  @override
  String get permissionName => RouteModel.passwordReset.permissionName;

  @override
  String get routeLocation => location;
}
