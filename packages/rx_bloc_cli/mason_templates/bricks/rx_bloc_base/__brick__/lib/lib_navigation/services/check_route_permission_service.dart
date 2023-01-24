import '../../base/common_services/permissions_service.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/routers/router.dart';

class CheckRoutePermissionService {
  CheckRoutePermissionService(this._permissionsService);

  final PermissionsService _permissionsService;

  Future<void> execute({
    required bool isLoggedIn,
    required String routePath,
  }) async {
    print('location use case: ${routePath}');
    if (!isLoggedIn && (routePath != '/' && routePath != '/login')) {
      throw NetworkErrorModel();
    }

    if (isLoggedIn && routePath == const LoginRoute().location) {
      return;
    }
  }
}
