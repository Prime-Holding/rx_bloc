import 'package:go_router/go_router.dart';

import '../../lib_permissions/services/permissions_service.dart';
import '../models/route_data_model.dart';

class RouterService {
  RouterService(this._router, this._permissionsService);
  final GoRouter _router;
  final PermissionsService _permissionsService;

  Future<void> go(RouteDataModel route, Object? extra) async {
    await _permissionsService.checkPermission(route.permissionName);
    _router.go(route.routeLocation, extra: extra);
  }

  Future<void> goToLocation(String route) async => _router.go(route);

  Future<T?> push<T extends Object?>(
      RouteDataModel route, {
      Object? extra,
  }) async {
    await _permissionsService.checkPermission(route.permissionName);
    return await _router.push<T>(route.routeLocation, extra: extra);
  }

  Future<T?> replace<T>(RouteDataModel route, Object? extra) async {
    await _permissionsService.checkPermission(route.permissionName);
    return await _router.replace(route.routeLocation, extra: extra);
  }

  void pop([Object? result]) => _router.pop(result);
}
