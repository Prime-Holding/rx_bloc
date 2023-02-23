part of '../../router.dart';

@TypedGoRoute<ProfileRoute>(path: RoutesPath.profile, routes: [
  TypedGoRoute<NotificationsRoute>(
    path: RoutesPath.notifications,
  ),
])
@immutable
class ProfileRoute extends GoRouteData implements RouteData {
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
