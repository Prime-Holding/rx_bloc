part of '../router.dart';

@TypedGoRoute<PhoneChangeRoute>(
  path: RoutesPath.phoneChange,
  routes: [
    TypedGoRoute<PhoneChangeConfirmRoute>(path: RoutesPath.phoneChangeConfirm)
  ],
)
@immutable
class PhoneChangeRoute extends GoRouteData implements RouteDataModel {
  const PhoneChangeRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const OnboardingPhonePageWithDependencies(isOnboarding: false),
      );

  @override
  String get permissionName => RouteModel.phoneChange.permissionName;

  @override
  String get routeLocation => location;
}

@immutable
class PhoneChangeConfirmRoute extends GoRouteData implements RouteDataModel {
  const PhoneChangeConfirmRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const OnboardingPhoneConfirmPageWithDependencies(
            isOnboarding: false),
      );

  @override
  String get permissionName => RouteModel.phoneChangeConfirm.permissionName;

  @override
  String get routeLocation => location;
}
