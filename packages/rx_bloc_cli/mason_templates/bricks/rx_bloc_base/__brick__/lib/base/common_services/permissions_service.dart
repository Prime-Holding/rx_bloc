{{> licence.dart }}

import '../models/errors/error_model.dart';
import '../models/permission_list_model.dart';
import '../repositories/permissions_repository.dart';

class PermissionsService {
  PermissionsService(this._permissionsRepository);

  final PermissionsRepository _permissionsRepository;
  PermissionListModel? _permissionList;

  Future<void> checkPermission(String key) async {
    if (await hasPermission(key)) {
      return;
    }

    AccessDeniedErrorModel();
  }

  Future<bool> hasPermission(String key) async {
    final permissions = await getPermissions();
    return permissions.item[key] ?? true;
  }

  bool hasPermissionSync(String key) {
    return _permissionList?.item[key] ?? true;
  }

  Future<PermissionListModel> getPermissions({bool force = false}) async {
    if (_permissionList == null || force) {
      _permissionList = await _permissionsRepository.getPermissions();
    }

    return _permissionList!;
  }

  Future<void> load() async {
    await getPermissions(force: true);
  }
}