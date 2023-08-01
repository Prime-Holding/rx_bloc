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
{{/enable_feature_otp}}{{#enable_pin_code}}
@TypedGoRoute<VerifyPinCodeRoute>(path: RoutesPath.verifyPinCode)
@immutable
class VerifyPinCodeRoute extends GoRouteData implements RouteDataModel {
  const VerifyPinCodeRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: VerifyPinCodePage(
          pinCodeArguments: state.extra as PinCodeArguments,
        ),
      );

  @override
  String get permissionName => RouteModel.dashboard.permissionName;

  @override
  String get routeLocation => location;
}{{/enable_pin_code}}