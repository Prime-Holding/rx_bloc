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

@TypedGoRoute<AuthMatrixOtpRoute>(
  path: RoutesPath.authMatrixOtp,
)
class AuthMatrixOtpRoute extends GoRouteData
    with EquatableMixin
    implements RouteDataModel {
  const AuthMatrixOtpRoute(
    this.transactionId,
  );
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;
  final String transactionId;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: AuthMatrixOtpPageWithDependencies(
          transactionId: transactionId,
          authMatrixResponse: state.extra as AuthMatrixResponse,
        ),
      );

  @override
  String get permissionName => RouteModel.authMatrix.permissionName;

  @override
  String get routeLocation => location;

  @override
  List<Object?> get props => [transactionId, routeLocation];
}

@TypedGoRoute<AuthMatrixPinBiometricsRoute>(
  path: RoutesPath.authMatrixPinBiometrics,
)
class AuthMatrixPinBiometricsRoute extends GoRouteData
    with EquatableMixin
    implements RouteDataModel {
  const AuthMatrixPinBiometricsRoute(
    this.transactionId,
  );

  final String transactionId;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: AuthMatrixPinBiometricsPageWithDependencies(
          transactionId: transactionId,
          authMatrixResponse: state.extra as AuthMatrixResponse,
        ),
      );

  @override
  String get permissionName => RouteModel.authMatrix.permissionName;

  @override
  String get routeLocation => location;

  @override
  List<Object?> get props => [transactionId, routeLocation];
}
