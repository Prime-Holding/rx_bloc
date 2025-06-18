part of '../router.dart';

@immutable
class PasswordResetRequestRoute extends GoRouteData
    with _$PasswordResetRequestRoute
    implements RouteDataModel {
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

@immutable
class PasswordResetConfirmationRoute extends GoRouteData
    with _$PasswordResetConfirmationRoute
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

@immutable
class PasswordResetRoute extends GoRouteData
    with _$PasswordResetRoute
    implements RouteDataModel {
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
