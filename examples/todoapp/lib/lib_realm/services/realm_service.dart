import 'package:realm/realm.dart';

import '../../base/app/config/environment_config.dart';
import '../../base/models/todo_model.dart';
import '../repositories/realm_init_repository.dart';

class RealmService {
  RealmService(this._realmInitRepository);

  late final Realm realm;
  final RealmInitRepository _realmInitRepository;

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
    final user = await _realmInitRepository.getRealmUser(app);
    final realmConfig = Configuration.flexibleSync(user, [TodoModel.schema]);
    realm = Realm(realmConfig);
    final realmModel = realm.all<TodoModel>();

    await _realmInitRepository.updateSubscriptions(realm, realmModel);
  }
}
