part of '../router.dart';

{{#has_authentication}}
@TypedGoRoute<LoginRoute>(
  path: RoutesPath.login, {{#enable_feature_onboarding}}
  routes: [
    TypedGoRoute<OnboardingRoute>(
      path: RoutesPath.onboarding,
      routes: [
        TypedGoRoute<OnboardingEmailConfirmationRoute>(
            path: RoutesPath.onboardingEmailConfirmation),
        TypedGoRoute<OnboardingPhoneRoute>(
          path: RoutesPath.onboardingPhone,
          routes: [
            TypedGoRoute<OnboardingPhoneConfirmRoute>(
                path: RoutesPath.onboardingPhoneConfirm),
          ],
        ),
      ],
    ),{{#enable_forgotten_password}}
    TypedGoRoute<PasswordResetRequestRoute>(
      path: RoutesPath.passwordResetRequest,
      routes: [
        TypedGoRoute<PasswordResetConfirmationRoute>(
            path: RoutesPath.passwordResetConfirmation),
      ],
    ),
    TypedGoRoute<PasswordResetRoute>(path: RoutesPath.passwordReset),{{/enable_forgotten_password}}
  ],{{/enable_feature_onboarding}}
)
@immutable
class LoginRoute extends GoRouteData with _$LoginRoute implements RouteDataModel {
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
}{{/has_authentication}}{{#enable_feature_otp}}

@TypedGoRoute<OtpRoute>(path: RoutesPath.otpRoute)
@immutable
class OtpRoute extends GoRouteData with _$OtpRoute implements RouteDataModel {
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
class VerifyPinCodeRoute extends GoRouteData with _$VerifyPinCodeRoute implements RouteDataModel {
  const VerifyPinCodeRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: VerifyPinCodePage(),
      );

  @override
  String get permissionName => RouteModel.dashboard.permissionName;

  @override
  String get routeLocation => location;
}{{/enable_pin_code}}
