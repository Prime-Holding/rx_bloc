{{> licence.dart }}

import '../../lib_permissions/services/permissions_service.dart';

class SplashService {
  SplashService(this.permissionsService);

  final PermissionsService permissionsService;

  Future<void> initializeApp() async {
    await permissionsService.load();
  }
}
