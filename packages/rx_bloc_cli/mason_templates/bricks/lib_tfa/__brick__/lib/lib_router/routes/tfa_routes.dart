{{> licence.dart }}

part of '../router.dart';

@immutable
class TFABranchData extends StatefulShellBranchData {
  const TFABranchData();
}

@immutable
class FeatureTFARoute extends GoRouteData implements RouteDataModel {
  const FeatureTFARoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const TFAPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.tfa.permissionName;

  @override
  String get routeLocation => location;
}

@TypedGoRoute<TFAOtpRoute>(
  path: RoutesPath.tfaOtp,
)
class TFAOtpRoute extends GoRouteData
    with EquatableMixin
    implements RouteDataModel {
  const TFAOtpRoute(
    this.transactionId,
  );
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;
  final String transactionId;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: TFAOtpPageWithDependencies(
          transactionId: transactionId,
          tfaResponse: state.extra as TFAResponse,
        ),
      );

  @override
  String get permissionName => RouteModel.tfa.permissionName;

  @override
  String get routeLocation => location;

  @override
  List<Object?> get props => [transactionId, routeLocation];
}

@TypedGoRoute<TFAPinBiometricsRoute>(
  path: RoutesPath.tfaPinBiometrics,
)
class TFAPinBiometricsRoute extends GoRouteData
    with EquatableMixin
    implements RouteDataModel {
  const TFAPinBiometricsRoute(
    this.transactionId,
  );

  final String transactionId;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: TFAPinBiometricsPageWithDependencies(
          transactionId: transactionId,
          tfaResponse: state.extra as TFAResponse,
        ),
      );

  @override
  String get permissionName => RouteModel.tfa.permissionName;

  @override
  String get routeLocation => location;

  @override
  List<Object?> get props => [transactionId, routeLocation];
}
