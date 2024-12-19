part of '../router.dart';

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
