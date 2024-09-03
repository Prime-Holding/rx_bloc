import 'package:realm/realm.dart';

import '../../../base/app/initialization/realm_instance.dart';
import '../../models/permission_map_model.dart';
import '../../models/permission_model.dart';

class PermissionsLocalDataSource {
  PermissionsLocalDataSource({required this.realmInstance});
  final RealmInstance realmInstance;

  void addPermisions(String id, Map<String, bool> permissions) {
    final oldPermission = realmInstance.realm.find<PermissionModel>(id);

    final RealmList<PermissionMap> permissionMap = RealmList<PermissionMap>(
      permissions.entries.map(
        (permission) => PermissionMap(permission.key, permission.value),
      ),
    );

    /// Update permissions if they already exist
    if (oldPermission != null) {
      realmInstance.realm.write(() {
        oldPermission.permissions.clear();
        oldPermission.permissions.addAll(permissionMap);
      });
    }

    /// Add permissions if they don't exist
    else {
      realmInstance.realm.write(() {
        realmInstance.realm.add<PermissionModel>(
          PermissionModel(id, permissions: permissionMap),
        );
      });
    }
  }

  Map<String, bool> getPermissions(String id) {
    final permissions = realmInstance.realm.find<PermissionModel>(id);

    if (permissions == null) {
      return {};
    }

    return {
      for (var permission in permissions.permissions)
        permission.permissionName: permission.isEnabled
    };
  }
}
