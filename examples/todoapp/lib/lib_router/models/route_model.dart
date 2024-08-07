// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../../lib_permissions/models/route_permissions.dart';
import 'routes_path.dart';

enum RouteModel {
  todoDetails(
    pathName: RoutesPath.todoDetails,
    fullPath: '/todo-list/details/:id',
    permissionName: RoutePermissions.todoDetails,
  ),
  todoCreate(
    pathName: RoutesPath.todoCreate,
    fullPath: '/todo-list/create',
    permissionName: RoutePermissions.todoManagement,
  ),
  todoUpdate(
    pathName: RoutesPath.todoUpdate,
    fullPath: '/todo-list/details/:id/update',
    permissionName: RoutePermissions.todoManagement,
  ),
  stats(
    pathName: RoutesPath.stats,
    fullPath: '/stats',
    permissionName: RoutePermissions.stats,
  ),
  todoList(
    pathName: RoutesPath.todoList,
    fullPath: '/todo-list',
    permissionName: RoutePermissions.todoList,
  ),

  splash(
    pathName: RoutesPath.splash,
    fullPath: '/splash',
    permissionName: RoutePermissions.splash,
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
