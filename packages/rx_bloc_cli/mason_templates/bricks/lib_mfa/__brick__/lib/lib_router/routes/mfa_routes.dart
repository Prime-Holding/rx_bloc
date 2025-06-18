{{> licence.dart }}

part of '../router.dart';

@immutable
class MfaBranchData extends StatefulShellBranchData {
  const MfaBranchData();
}

@immutable
class FeatureMfaRoute extends GoRouteData with _$FeatureMfaRoute implements RouteDataModel {
  const FeatureMfaRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const MfaPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.mfa.permissionName;

  @override
  String get routeLocation => location;
}

@TypedGoRoute<MfaOtpRoute>(path: RoutesPath.mfaOtp)
class MfaOtpRoute extends GoRouteData
    with EquatableMixin, _$MfaOtpRoute
    implements RouteDataModel {
  const MfaOtpRoute(
    this.transactionId,
  );
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;
  final String transactionId;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: MfaOtpPageWithDependencies(
          transactionId: transactionId,
          mfaResponse: state.extra as MfaResponse,
        ),
      );

  @override
  String get permissionName => RouteModel.mfaOtp.permissionName;

  @override
  String get routeLocation => location;

  @override
  List<Object?> get props => [transactionId, routeLocation];
}

@TypedGoRoute<MfaPinBiometricsRoute>(path: RoutesPath.mfaPinBiometrics)
class MfaPinBiometricsRoute extends GoRouteData
    with EquatableMixin, _$MfaPinBiometricsRoute
    implements RouteDataModel {
  const MfaPinBiometricsRoute(this.transactionId);

  final String transactionId;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: MfaPinBiometricsPageWithDependencies(
          transactionId: transactionId,
          mfaResponse: state.extra as MfaResponse,
        ),
      );

  @override
  String get permissionName => RouteModel.mfaPinBiometrics.permissionName;

  @override
  String get routeLocation => location;

  @override
  List<Object?> get props => [transactionId, routeLocation];
}
