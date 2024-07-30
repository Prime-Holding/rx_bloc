{{> licence.dart }}

part of '../router.dart';

@immutable
class MFABranchData extends StatefulShellBranchData {
  const MFABranchData();
}

@immutable
class FeatureMFARoute extends GoRouteData implements RouteDataModel {
  const FeatureMFARoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const MFAPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.mfa.permissionName;

  @override
  String get routeLocation => location;
}

@TypedGoRoute<MFAOtpRoute>(
  path: RoutesPath.mfaOtp,
)
class MFAOtpRoute extends GoRouteData
    with EquatableMixin
    implements RouteDataModel {
  const MFAOtpRoute(
    this.transactionId,
  );
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;
  final String transactionId;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: MFAOtpPageWithDependencies(
          transactionId: transactionId,
          mfaResponse: state.extra as MFAResponse,
        ),
      );

  @override
  String get permissionName => RouteModel.mfa.permissionName;

  @override
  String get routeLocation => location;

  @override
  List<Object?> get props => [transactionId, routeLocation];
}

@TypedGoRoute<MFAPinBiometricsRoute>(
  path: RoutesPath.mfaPinBiometrics,
)
class MFAPinBiometricsRoute extends GoRouteData
    with EquatableMixin
    implements RouteDataModel {
  const MFAPinBiometricsRoute(
    this.transactionId,
  );

  final String transactionId;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: MFAPinBiometricsPageWithDependencies(
          transactionId: transactionId,
          mfaResponse: state.extra as MFAResponse,
        ),
      );

  @override
  String get permissionName => RouteModel.mfa.permissionName;

  @override
  String get routeLocation => location;

  @override
  List<Object?> get props => [transactionId, routeLocation];
}
