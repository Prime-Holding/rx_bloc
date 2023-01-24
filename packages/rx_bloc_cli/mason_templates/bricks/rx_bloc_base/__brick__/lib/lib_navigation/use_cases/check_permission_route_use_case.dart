{{> licence.dart }}

import '../../base/common_services/permissions_service.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/routers/router.dart';

class CheckPermissionRouteUseCase {
  CheckPermissionRouteUseCase(this._permissionsService);

  final PermissionsService _permissionsService;

  Future<void> execute({
    required bool isLoggedIn,
    required String routePath,
  }) async {
    if (!isLoggedIn && (routePath != '/' && routePath != '/login')) {
      throw NetworkErrorModel();
    }

    if (isLoggedIn && routePath == const LoginRoute().location) {
      return;
    }
  }
}
