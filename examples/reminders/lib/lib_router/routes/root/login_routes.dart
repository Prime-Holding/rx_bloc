part of '../../router.dart';

@TypedGoRoute<LoginRoute>(path: RoutesPath.login)
@immutable
class LoginRoute extends GoRouteData implements RouteData {
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
