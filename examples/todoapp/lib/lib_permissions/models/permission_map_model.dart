import 'package:realm/realm.dart';
part 'permission_map_model.realm.dart';

@RealmModel(ObjectType.embeddedObject)
class $PermissionMap {
  ///  The name of the permission that is being checked.
  late String permissionName;

  /// Whether the permission is enabled or not.
  late bool isEnabled;
}
