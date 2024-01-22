part of '../../router.dart';

/// Route used for navigating to the login page
@TypedGoRoute<LoginRoute>(path: RoutesPath.login)
@immutable
class LoginRoute extends GoRouteData implements RouteDataModel {
  const LoginRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const FacebookLoginPage(),
      );

  @override
  String get routeLocation => location;
}
