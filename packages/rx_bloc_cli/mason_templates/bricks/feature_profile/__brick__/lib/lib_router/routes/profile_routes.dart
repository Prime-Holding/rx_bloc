part of '../router.dart';

@immutable
class ProfileBranchData extends StatefulShellBranchData {
  const ProfileBranchData();
}

@immutable
class ProfileRoute extends GoRouteData with _$ProfileRoute implements RouteDataModel {
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
} {{#enable_pin_code}}

@TypedGoRoute<SetPinRoute>(path: RoutesPath.setPinCode)
@immutable
class SetPinRoute extends GoRouteData with _$SetPinRoute implements RouteDataModel {
  const SetPinRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: SetPinPageWithDependencies(
          createPinModel: state.extra == null
              ? CreatePinSetModel()
              : state.extra as CreatePinModel,
        ),
      );

  @override
  String get permissionName => RouteModel.setPinCode.permissionName;

  @override
  String get routeLocation => location;
}

@TypedGoRoute<ConfirmPinRoute>(path: RoutesPath.confirmPinCode)
@immutable
class ConfirmPinRoute extends GoRouteData with _$ConfirmPinRoute implements RouteDataModel {
  const ConfirmPinRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: SetPinPageWithDependencies(
          createPinModel: state.extra == null
              ? CreatePinSetModel()
              : state.extra as CreatePinModel,
        ),
      );

  @override
  String get permissionName => RouteModel.confirmPinCode.permissionName;

  @override
  String get routeLocation => location;
}

@TypedGoRoute<UpdatePinRoute>(path: RoutesPath.updatePinCode)
@immutable
class UpdatePinRoute extends GoRouteData with _$UpdatePinRoute implements RouteDataModel {
  const UpdatePinRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: UpdatePinPageWithDependencies(
          updatePinModel: state.extra == null
              ? UpdatePinVerifyModel()
              : state.extra as UpdatePinModel,
        ),
      );

  @override
  String get permissionName => RouteModel.updatePinCode.permissionName;

  @override
  String get routeLocation => location;
} {{/enable_pin_code}}
