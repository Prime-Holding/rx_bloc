part of '../router.dart';

@TypedGoRoute<LoginRoute>(path: RoutesPath.login)
@immutable
class LoginRoute extends GoRouteData implements RouteDataModel {
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
{{#enable_feature_otp}}

@TypedGoRoute<OtpRoute>(path: RoutesPath.otpRoute)
@immutable
class OtpRoute extends GoRouteData implements RouteDataModel {
  const OtpRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const OtpPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.dashboard.permissionName;

  @override
  String get routeLocation => location;
}
{{/enable_feature_otp}}
