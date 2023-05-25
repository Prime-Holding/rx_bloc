part of '../router.dart';

@TypedGoRoute<ProfileRoute>(path: RoutesPath.profile, routes: [
  TypedGoRoute<NotificationsRoute>(
    path: RoutesPath.notifications,
  ),{{#enable_pin_code}}
  TypedGoRoute<PinCodeRoute>(
    path: RoutesPath.pinCode,
  ),{{/enable_pin_code}}
])
@immutable
class ProfileRoute extends GoRouteData implements RouteDataModel {
  const ProfileRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const ProfilePageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.profile.permissionName;

  @override
  String get routeLocation => location;
}

@immutable
class NotificationsRoute extends GoRouteData implements RouteDataModel {
  const NotificationsRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const NotificationsPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.notifications.permissionName;

  @override
  String get routeLocation => location;
}{{#enable_pin_code}}

@immutable
class PinCodeRoute extends GoRouteData implements RouteDataModel {
  const PinCodeRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: PinCodePage(
          title: state.extra.toString(),
        ),
      );

  @override
  String get permissionName => RouteModel.pinCode.permissionName;

  @override
  String get routeLocation => location;
}{{/enable_pin_code}}