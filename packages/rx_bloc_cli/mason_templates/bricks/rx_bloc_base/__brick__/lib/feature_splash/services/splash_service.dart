{{> licence.dart }}

import '../../lib_permissions/services/permissions_service.dart';

class SplashService {
  SplashService(this.permissionsService);

  final PermissionsService permissionsService;
  bool _appInitialized = false;

  Future<void> initializeApp() async {
    await permissionsService.load();
    _appInitialized = true;
  }

  bool get isAppInitialized => _appInitialized;
}
