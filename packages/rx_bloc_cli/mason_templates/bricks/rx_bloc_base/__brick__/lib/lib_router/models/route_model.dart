{{> licence.dart }}

class RoutePath {
  static const splash = 'splash';
  static const counter = '/';
  static const notifications = 'notifications';
  static const login = 'login';
  static const enterMessage = 'enterMessage';
  static const items = 'items';
  static const itemDetails = ':id';
}

enum RouteModel {
  splash(
    pathName: RoutePath.splash,
    fullPath: '/splash',
    permissionName: 'SplashRoute',
  ),
  counter(
    pathName: RoutePath.counter,
    fullPath: '/',
    permissionName: 'CounterRoute',
  ),
  notifications(
    pathName: RoutePath.notifications,
    fullPath: '/notifications',
    permissionName: 'NotificationRoute',
  ),
  login(
    pathName: RoutePath.login,
    fullPath: '/login',
    permissionName: 'LoginRoute',
  ),
  enterMessage(
    pathName: RoutePath.enterMessage,
    fullPath: '/enterMessage',
    permissionName: 'EnterMessageRoute',
  ),
  items(
    pathName: RoutePath.items,
    fullPath: '/items',
    permissionName: 'ItemsRoute',
  ),
  itemDetails(
    pathName: RoutePath.itemDetails,
    fullPath: '/items/:id',
    permissionName: 'ItemDetailsRoute',
  );

  final String pathName;
  final String fullPath;
  final String permissionName;

  const RouteModel({
    required this.pathName,
    required this.fullPath,
    required this.permissionName,
  });

  static final Map<String, String> nameByPath = {};

  static String? getRouteNameByFullPath(String path) {
    if (nameByPath.isEmpty) {
      for (RouteModel paths in RouteModel.values) {
        nameByPath[paths.fullPath] = paths.permissionName;
      }
    }
    return nameByPath[path];
  }
}
