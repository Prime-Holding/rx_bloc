part of '../router.dart';

@immutable
class OnboardingRoute extends GoRouteData
    with _$OnboardingRoute
    implements RouteDataModel {
  const OnboardingRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const OnboardingPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.onboarding.permissionName;

  @override
  String get routeLocation => location;
}

@immutable
class OnboardingEmailConfirmationRoute extends GoRouteData
    with _$OnboardingEmailConfirmationRoute
    implements RouteDataModel {
  const OnboardingEmailConfirmationRoute(this._email);

  final String _email;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: OnboardingEmailConfirmationPageWithDependencies(email: _email),
      );

  @override
  String get permissionName =>
      RouteModel.onboardingEmailConfirmation.permissionName;

  @override
  String get routeLocation => location;
}

@TypedGoRoute<OnboardingEmailConfirmedRoute>(
    path: RoutesPath.onboardingEmailConfirmed)
@immutable
class OnboardingEmailConfirmedRoute extends GoRouteData
    with _$OnboardingEmailConfirmedRoute
    implements RouteDataModel {
  const OnboardingEmailConfirmedRoute(this.token);

  final String token;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: OnboardingEmailConfirmedPageWithDependencies(
          verifyEmailToken: token,
          isOnboarding: true,
        ),
      );

  @override
  String get permissionName =>
      RouteModel.onboardingEmailConfirmed.permissionName;

  @override
  String get routeLocation => location;
}

@immutable
class OnboardingPhoneRoute extends GoRouteData
    with _$OnboardingPhoneRoute
    implements RouteDataModel {
  const OnboardingPhoneRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: OnboardingPhonePageWithDependencies(isOnboarding: true),
      );

  @override
  String get permissionName => RouteModel.onboardingPhone.permissionName;

  @override
  String get routeLocation => location;
}

@immutable
class OnboardingPhoneConfirmRoute extends GoRouteData
    with _$OnboardingPhoneConfirmRoute
    implements RouteDataModel {
  const OnboardingPhoneConfirmRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: OnboardingPhoneConfirmPageWithDependencies(isOnboarding: true),
      );

  @override
  String get permissionName => RouteModel.onboardingPhone.permissionName;

  @override
  String get routeLocation => location;
}
