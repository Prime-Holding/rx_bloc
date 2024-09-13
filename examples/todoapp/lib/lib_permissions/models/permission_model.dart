import 'package:realm/realm.dart';

import 'permission_map_model.dart';

part 'permission_model.realm.dart';

@RealmModel()
class $PermissionModel {
  @PrimaryKey()
  @MapTo('_id')
  late final String? id;
  late final List<$PermissionMap> permissions;
}
