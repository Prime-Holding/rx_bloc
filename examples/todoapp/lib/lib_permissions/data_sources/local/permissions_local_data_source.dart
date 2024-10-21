import 'package:realm/realm.dart';

import '../../models/permission_map_model.dart';
import '../../models/permission_model.dart';

class PermissionsLocalDataSource {
  PermissionsLocalDataSource({required this.realmInstance});
  final Realm realmInstance;
  static const String _permissionsKey = 'permissions';

  void storePermissions(Map<String, bool> permissions) {
    final oldPermission = realmInstance.find<PermissionModel>(_permissionsKey);

    final RealmList<PermissionMap> permissionMap = RealmList<PermissionMap>(
      permissions.entries.map(
        (permission) => PermissionMap(permission.key, permission.value),
      ),
    );

    /// Update permissions if they already exist
    if (oldPermission != null) {
      realmInstance.write(() {
        oldPermission.permissions.clear();
        oldPermission.permissions.addAll(permissionMap);
      });
    }

    /// Add permissions if they don't exist
    else {
      realmInstance.write(() {
        realmInstance.add<PermissionModel>(
          PermissionModel(_permissionsKey, permissions: permissionMap),
        );
      });
    }
  }

  Map<String, bool> getPermissions() {
    final permissions = realmInstance.find<PermissionModel>(_permissionsKey);

    if (permissions == null) {
      return {};
    }

    return Map.fromEntries(
      permissions.permissions.map(
        (permission) =>
            MapEntry(permission.permissionName, permission.isEnabled),
      ),
    );
  }
}
