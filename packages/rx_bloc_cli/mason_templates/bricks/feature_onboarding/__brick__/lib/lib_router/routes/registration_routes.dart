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
        ),
      );

  @override
  String get permissionName =>
      RouteModel.onboardingEmailConfirmed.permissionName;

  @override
  String get routeLocation => location;
}
