import 'package:realm/realm.dart';

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../../base/models/todo_model.dart';
import '../services/realm_service.dart';

class RealmInitRepository {
  RealmInitRepository(this._errorMapper);

  final ErrorMapper _errorMapper;

  Future<User> getRealmUser(App app) => _errorMapper.execute(
        () async => app.currentUser ?? await app.logIn(Credentials.anonymous()),
      );

  Future<void> updateSubscriptions(
    Realm realm,
    RealmResults<TodoModel> realmModel,
  ) =>
      _errorMapper.execute(() async {
        if (realm.subscriptions.findByName(RealmService.queryAllTodos) ==
            null) {
          realm.subscriptions.update((mutableSubscriptions) {
            mutableSubscriptions.add(
              realmModel,
              name: RealmService.queryAllTodos,
            );
          });
        }
        await realm.subscriptions.waitForSynchronization();
      });
}
