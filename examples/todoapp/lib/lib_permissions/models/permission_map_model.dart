import 'package:realm/realm.dart';
part 'permission_map_model.realm.dart';

@RealmModel(ObjectType.embeddedObject)
class $PermissionMap {
  late String key;
  late bool value;
}
