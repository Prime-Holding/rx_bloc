{{> licence.dart }}

part of '../router.dart';

@immutable
class AuthMatrixBranchData extends StatefulShellBranchData {
  const AuthMatrixBranchData();
}

@immutable
class FeatureAuthMatrixRoute extends GoRouteData implements RouteDataModel {
  const FeatureAuthMatrixRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const AuthMatrixPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.authMatrix.permissionName;

  @override
  String get routeLocation => location;
}

@immutable
class AuthMatrixOtpRoute extends GoRouteData implements RouteDataModel {
  const AuthMatrixOtpRoute(
    this.endToEndId,
  );
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;
  final String endToEndId;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: AuthMatrixOtpPageWithDependencies(
          response: state.extra as AuthMatrixResponse,
          endToEndId: endToEndId,
        ),
      );

  @override
  String get permissionName => RouteModel.authMatrix.permissionName;

  @override
  String get routeLocation => location;
}

@immutable
class AuthMatrixPinBiometricsRoute extends GoRouteData
    implements RouteDataModel {
  const AuthMatrixPinBiometricsRoute(
    this.endToEndId,
  );
  
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;
  final String endToEndId;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: AuthMatrixPinBiometricsPageWithDependencies(
          response: state.extra as AuthMatrixResponse,
          endToEndId: endToEndId,
        ),
      );

  @override
  String get permissionName => RouteModel.authMatrix.permissionName;

  @override
  String get routeLocation => location;
}
