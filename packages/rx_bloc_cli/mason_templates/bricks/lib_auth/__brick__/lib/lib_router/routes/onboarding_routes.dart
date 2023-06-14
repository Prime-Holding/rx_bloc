part of '../router.dart';

@TypedGoRoute<LoginRoute>(path: RoutesPath.login)
@immutable
class LoginRoute extends GoRouteData implements RouteDataModel {
  const LoginRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: {{#enable_login}}const LoginPageWithDependencies(){{/enable_login}}{{^enable_login}}const LoginPage(){{/enable_login}},
      );

  @override
  String get permissionName => RouteModel.login.permissionName;

  @override
  String get routeLocation => location;
}
