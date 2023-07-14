part of '../router.dart';

@TypedGoRoute<ProfileRoute>(path: RoutesPath.profile, routes: [
  TypedGoRoute<NotificationsRoute>(
    path: RoutesPath.notifications,
  ),{{#enable_pin_code}}
  TypedGoRoute<CreatePinRoute>(
  path: RoutesPath.createPin,
  ),
  TypedGoRoute<ConfirmPinRoute>(
  path: RoutesPath.confirmPin,
  ),
  TypedGoRoute<UpdatePinRoute>(
  path: RoutesPath.updatePin,
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
class CreatePinRoute extends GoRouteData implements RouteDataModel {
  const CreatePinRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
    MaterialPage(
    key: state.pageKey,
    child: CreatePinPage(
    pinCodeArguments: state.extra as PinCodeArguments,
    ),
  );

  @override
  String get permissionName => RouteModel.pinCode.permissionName;

  @override
  String get routeLocation => location;
}

@immutable
class ConfirmPinRoute extends GoRouteData implements RouteDataModel {
  const ConfirmPinRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
    MaterialPage(
    key: state.pageKey,
    child: ConfirmPinPage(
    pinCodeArguments: state.extra as PinCodeArguments,
    ),
  );

  @override
  String get permissionName => RouteModel.pinCode.permissionName;

  @override
  String get routeLocation => location;
}

@immutable
class UpdatePinRoute extends GoRouteData implements RouteDataModel {
  const UpdatePinRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
    MaterialPage(
    key: state.pageKey,
    child: UpdatePinPage(
    pinCodeArguments: state.extra as PinCodeArguments,
  ),
);

@override
String get permissionName => RouteModel.pinCode.permissionName;

@override
String get routeLocation => location;
}{{/enable_pin_code}}