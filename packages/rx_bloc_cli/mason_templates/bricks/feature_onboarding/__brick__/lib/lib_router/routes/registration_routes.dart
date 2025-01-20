part of '../router.dart';

@TypedGoRoute<OnboardingRoute>(path: RoutesPath.onboarding)
@immutable
class OnboardingRoute extends GoRouteData implements RouteDataModel {
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

@TypedGoRoute<OnboardingEmailConfirmationRoute>(
    path: RoutesPath.onboardingEmailConfirmation)
@immutable
class OnboardingEmailConfirmationRoute extends GoRouteData
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

@TypedGoRoute<OnboardingPhoneRoute>(path: RoutesPath.onboardingPhone)
@immutable
class OnboardingPhoneRoute extends GoRouteData implements RouteDataModel {
  const OnboardingPhoneRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const OnboardingPhonePageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.onboardingPhone.permissionName;

  @override
  String get routeLocation => location;
}

@TypedGoRoute<OnboardingPhoneConfirmRoute>(
    path: RoutesPath.onboardingPhoneConfirm)
@immutable
class OnboardingPhoneConfirmRoute extends GoRouteData
    implements RouteDataModel {
  const OnboardingPhoneConfirmRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const OnboardingPhoneConfirmPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.onboardingPhone.permissionName;

  @override
  String get routeLocation => location;
}
