import 'package:realm/realm.dart';

import '../../base/data_sources/local/connectivity_data_source.dart';
import '../../base/models/todo_model.dart';
import '../repositories/realm_init_repository.dart';

class RealmService {
  RealmService(this.realmInitRepository);

  static const String queryAllTodos = 'getAllTodos';
  static const String _realmAppId = 'remindersservice-rlxovpu';

  late Realm realm;
  final RealmInitRepository realmInitRepository;
  final ConnectivityDataSource connectivityDataSource =
      ConnectivityDataSource();
  Future<void> initializeRealm() async {
    final app = App(
      AppConfiguration(
        _realmAppId,
        syncTimeoutOptions: const SyncTimeoutOptions(
          connectTimeout: Duration(seconds: 30),
          connectionLingerTime: Duration(seconds: 15),
          pingKeepAlivePeriod: Duration(seconds: 30),
          pongKeepAliveTimeout: Duration(seconds: 30),
          fastReconnectLimit: Duration(seconds: 15),
        ),
      ),
    );
    final user = await realmInitRepository.getRealmUser(app);
    final realmConfig = Configuration.flexibleSync(user, [TodoModel.schema]);
    realm = Realm(realmConfig);
    final realmModel = realm.all<TodoModel>();

    await realmInitRepository.updateSubscriptions(realm, realmModel);
  }
}
