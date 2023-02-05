part of '../router.dart';

@immutable
class EnterMessageRoute extends GoRouteData implements RouteData {
  const EnterMessageRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const EnterMessageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.enterMessage.permissionName;

  @override
  String get routeLocation => location;
}
