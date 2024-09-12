import 'package:realm/realm.dart';

import '../../../lib_permissions/models/permission_map_model.dart';
import '../../../lib_permissions/models/permission_model.dart';
import '../../models/todo_model.dart';

class RealmInstance {
  Realm initializeRealm() {
    return Realm(Configuration.local([
      TodoModel.schema,
      PermissionMap.schema,
      PermissionModel.schema,
    ]));
  }
}
