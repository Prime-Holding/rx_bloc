part of '../router.dart';

@immutable
class LoginRoute extends GoRouteData implements RouteData {
  const LoginRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const LoginPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.login.permissionName;

  @override
  String get routeLocation => location;
}
