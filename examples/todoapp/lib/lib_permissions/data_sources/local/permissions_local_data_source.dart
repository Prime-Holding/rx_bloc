import '../../../base/app/initialization/realm_instance.dart';
import '../../models/permission_model.dart';

class PermissionsLocalDataSource {
  PermissionsLocalDataSource({required this.realmInstance});
  final RealmInstance realmInstance;

  void savePermissions(PermissionModel permissions) {
    realmInstance.realm.write(() {
      realmInstance.realm.add<PermissionModel>(permissions);
    });
  }

  Map<String, bool> getPermissions() {
    final results = realmInstance.realm.all<PermissionModel>();

    if (results.isEmpty) {
      return {};
    }
    final permissions = results.first;
    return {for (var pair in permissions.permissions) pair.key: pair.value};
  }
}
