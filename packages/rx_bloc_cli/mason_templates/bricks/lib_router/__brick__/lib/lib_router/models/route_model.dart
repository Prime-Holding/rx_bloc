{{> licence.dart }}

import '../../lib_permissions/models/route_permissions.dart';
import 'routes_path.dart';

enum RouteModel {
  dashboard(
    pathName: RoutesPath.dashboard,
    fullPath: '/dashboard',
    permissionName: RoutePermissions.dashboard,
  ),
  profile(
    pathName: RoutesPath.profile,
    fullPath: '/profile',
    permissionName: RoutePermissions.profile,
  ),
  splash(
    pathName: RoutesPath.splash,
    fullPath: '/splash',
    permissionName: RoutePermissions.splash,
  ),{{#enable_feature_counter}}
  counter(
    pathName: RoutesPath.counter,
    fullPath: '/counter',
    permissionName: RoutePermissions.counter,
  ),{{/enable_feature_counter}}{{#enable_feature_widget_toolkit}}
  widgetToolkit(
    pathName: RoutesPath.widgetToolkit,
    fullPath: '/widget-toolkit',
    permissionName: RoutePermissions.widgetToolkit,
  ),{{/enable_feature_widget_toolkit}}
  notifications(
    pathName: RoutesPath.notifications,
    fullPath: '/notifications',
    permissionName: RoutePermissions.notifications,
  ),{{#enable_pin_code}}
  pinCode(
    pathName: RoutesPath.verifyPinCode,
    fullPath: '/verifyPinCode',
    permissionName: RoutePermissions.pinCode,
  ),{{/enable_pin_code}}{{#has_authentication}}
  login(
    pathName: RoutesPath.login,
    fullPath: '/login',
    permissionName: RoutePermissions.login,
  ),{{/has_authentication}}{{#enable_feature_deeplinks}}
  enterMessage(
    pathName: RoutesPath.enterMessage,
    fullPath: '/enterMessage',
    permissionName: RoutePermissions.enterMessage,
  ),
  deepLinks(
    pathName: RoutesPath.deepLinks,
    fullPath: '/deepLinks',
    permissionName: RoutePermissions.deepLinks,
  ),
  deepLinkDetails(
    pathName: RoutesPath.deepLinkDetails,
    fullPath: '/deepLinks/:id',
    permissionName: RoutePermissions.deepLinkDetails,
  ){{/enable_feature_deeplinks}};

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