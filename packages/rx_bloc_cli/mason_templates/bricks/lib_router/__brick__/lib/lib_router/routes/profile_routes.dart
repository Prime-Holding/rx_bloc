part of '../router.dart';

@immutable
class ProfileBranchData extends StatefulShellBranchData {
  const ProfileBranchData();
}

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
} {{#enable_pin_code}}

@immutable
class CreatePinRoute extends GoRouteData implements RouteDataModel {
  const CreatePinRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

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
class UpdatePinRoute extends GoRouteData implements RouteDataModel {
  const UpdatePinRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

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
} {{/enable_pin_code}}
