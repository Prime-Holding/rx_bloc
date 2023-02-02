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
    routeName: 'SplashRoute',
  ),
  counter(
    pathName: RouterPaths.counter,
    fullPath: '/',
    routeName: 'CounterRoute',
  ),
  notifications(
    pathName: RouterPaths.notifications,
    fullPath: '/notifications',
    routeName: 'NotificationRoute',
  ),
  login(
    pathName: RouterPaths.login,
    fullPath: '/login',
    routeName: 'LoginRoute',
  ),
  enterMessage(
    pathName: RouterPaths.enterMessage,
    fullPath: '/enterMessage',
    routeName: 'EnterMessageRoute',
  ),
  items(
    pathName: RouterPaths.items,
    fullPath: '/items',
    routeName: 'ItemsRoute',
  ),
  itemDetails(
    pathName: RouterPaths.itemDetails,
    fullPath: '/items/:id',
    routeName: 'ItemDetailsRoute',
  );

  final String pathName;
  final String fullPath;
  final String routeName;

  const RoutePathsModel({
    required this.pathName,
    required this.fullPath,
    required this.routeName,
  });

  static final Map<String, String> nameByPath = {};

  static String? getRouteNameByFullPath(String path) {
    if (nameByPath.isEmpty) {
      for (RoutePathsModel paths in RoutePathsModel.values) {
        nameByPath[paths.fullPath] = paths.routeName;
      }
    }
    return nameByPath[path];
  }
}
