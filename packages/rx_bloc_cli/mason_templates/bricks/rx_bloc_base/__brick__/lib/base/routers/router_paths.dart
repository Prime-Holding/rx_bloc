{{> licence.dart }}

class RouterPaths {
  static const String splash = '/splash';
  static const String counter = '/';
  static const String notifications = 'notifications';
  static const String login = 'login';
  static const String enterMessage = 'enterMessage';
  static const String items = 'items';
  static const String itemDetails = ':id';
}

enum RoutePathsModel {
  splash(
    pathName: RouterPaths.splash,
    fullPath: '/splash',
    permissionName: 'SplashRoute',
  ),
  counter(
    pathName: RouterPaths.counter,
    fullPath: '/',
    permissionName: 'CounterRoute',
  ),
  notifications(
    pathName: RouterPaths.notifications,
    fullPath: '/notifications',
    permissionName: 'NotificationRoute',
  ),
  login(
    pathName: RouterPaths.login,
    fullPath: '/login',
    permissionName: 'LoginRoute',
  ),
  enterMessage(
    pathName: RouterPaths.enterMessage,
    fullPath: '/enterMessage',
    permissionName: 'EnterMessageRoute',
  ),
  items(
    pathName: RouterPaths.items,
    fullPath: '/items',
    permissionName: 'ItemsRoute',
  ),
  itemDetails(
    pathName: RouterPaths.itemDetails,
    fullPath: '/items/:id',
    permissionName: 'ItemDetailsRoute',
  );

  final String pathName;
  final String fullPath;
  final String permissionName;

  const RoutePathsModel({
    required this.pathName,
    required this.fullPath,
    required this.permissionName,
  });

  static final Map<String, String> nameByPath = {};

  static String? getRouteNameByFullPath(String path) {
    if (nameByPath.isEmpty) {
      for (RoutePathsModel paths in RoutePathsModel.values) {
        nameByPath[paths.fullPath] = paths.permissionName;
      }
    }
    return nameByPath[path];
  }
}
