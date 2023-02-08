{{> licence.dart }}

import '../../lib_permissions/models/routes_permission.dart';
import 'routes_path.dart';

enum RouteModel {
  splash(
    pathName: RoutesPath.splash,
    fullPath: '/splash',
    permissionName: RoutesPermission.splash,
  ),
  counter(
    pathName: RoutesPath.counter,
    fullPath: '/',
    permissionName: RoutesPermission.counter,
  ),
  notifications(
    pathName: RoutesPath.notifications,
    fullPath: '/notifications',
    permissionName: RoutesPermission.notifications,
  ),
  login(
    pathName: RoutesPath.login,
    fullPath: '/login',
    permissionName: RoutesPermission.login,
  ),
  enterMessage(
    pathName: RoutesPath.enterMessage,
    fullPath: '/enterMessage',
    permissionName: RoutesPermission.enterMessage,
  ),
  items(
    pathName: RoutesPath.items,
    fullPath: '/items',
    permissionName: RoutesPermission.items,
  ),
  itemDetails(
    pathName: RoutesPath.itemDetails,
    fullPath: '/items/:id',
    permissionName: RoutesPermission.itemDetails,
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
