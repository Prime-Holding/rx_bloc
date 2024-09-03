import 'dart:async';

import 'package:realm/realm.dart';

import '../../../lib_permissions/models/permission_map_model.dart';
import '../../../lib_permissions/models/permission_model.dart';
import '../../models/todo_model.dart';
import '../config/environment_config.dart';

class RealmInstance {
  static const String _queryAllTodos = 'getAllTodos';
  static const String _queryPermissions = 'getPermissions';

  late final Realm realm;

  Future<void> initializeRealm() async {
    final app = App(
      AppConfiguration(
        EnvironmentConfig.realmAppId,
        syncTimeoutOptions: const SyncTimeoutOptions(
          connectTimeout: Duration(seconds: 30),
          connectionLingerTime: Duration(seconds: 15),
          pingKeepAlivePeriod: Duration(seconds: 30),
          pongKeepAliveTimeout: Duration(seconds: 30),
          fastReconnectLimit: Duration(seconds: 15),
        ),
      ),
    );
    final user = app.currentUser ?? await app.logIn(Credentials.anonymous());
    final realmConfig = Configuration.flexibleSync(
      user,
      [
        TodoModel.schema,
        PermissionMap.schema,
        PermissionModel.schema,
      ],
    );
    realm = Realm(
      realmConfig,
    );

    final todoModel = realm.all<TodoModel>();
    final permissionsModel = realm.all<PermissionModel>();

    await updateSubscriptions(
      realm,
      todoModel,
      permissionsModel,
    );
  }

  Future<void> updateSubscriptions(
    Realm realm,
    RealmResults<TodoModel> todoModel,
    RealmResults<PermissionModel> permissionsModel,
  ) async {
    if (realm.subscriptions.findByName(_queryAllTodos) == null) {
      realm.subscriptions.update((mutableSubscriptions) {
        mutableSubscriptions.add(
          todoModel,
          name: _queryAllTodos,
        );
      });
    }
    if (realm.subscriptions.findByName(_queryPermissions) == null) {
      realm.subscriptions.update((mutableSubscriptions) {
        mutableSubscriptions.add(
          permissionsModel,
          name: _queryPermissions,
        );
      });
    }

    await realm.subscriptions.waitForSynchronization();
  }
}
