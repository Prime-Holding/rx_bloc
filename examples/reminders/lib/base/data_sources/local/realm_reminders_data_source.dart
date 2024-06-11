import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:realm/realm.dart' hide Uuid;
import 'package:uuid/uuid.dart';

import '../../app/config/app_constants.dart';
import '../../app/config/environment_config.dart';
import '../../models/reminder/reminder_list_response.dart';
import '../../models/reminder/reminder_model.dart';
import '../../models/reminder/reminder_realm_model.dart';
import '../remote/reminders_data_source.dart';

class RealmRemindersDataSource extends RemindersDataSource {
  final Uuid _uuid;
  final Future<Realm> _realm;
  final FlutterSecureStorage _storage;

  static const _authorId = 'authorId';
  static const _anonymous = 'anonymous';

  static RealmRemindersDataSource? _instance;

  RealmRemindersDataSource._init(this._realm, this._uuid, this._storage);
  static RealmRemindersDataSource getInstance(
      FlutterSecureStorage storage, EnvironmentConfig evn, Uuid uuid) {
    if (_instance == null) {
      final realm = _initRealm(evn);
      _instance = RealmRemindersDataSource._init(realm, uuid, storage);
    }
    return _instance!;
  }

  static Future<Realm> _initRealm(EnvironmentConfig config) async {
    if (config == EnvironmentConfig.cloud) {
      final app = App(AppConfiguration('remindersservice-rlxovpu'));
      final user = await app.logIn(Credentials.anonymous());
      final realmConfig = Configuration.flexibleSync(
        user,
        [ReminderRealmModel.schema],
        encryptionKey: encryptionKey,
      );

      var realm = Realm(realmConfig);
      realm.subscriptions.update((mutableSubscriptions) {
        mutableSubscriptions.add(realm.all<ReminderRealmModel>());
      });
      await realm.subscriptions.waitForSynchronization();
      return realm;
    } else {
      final realmConfig = Configuration.local(
        [ReminderRealmModel.schema],
        encryptionKey: encryptionKey,
      );
      return Realm(realmConfig);
    }
  }

  @override
  Future<ReminderModel> create(
      {required String title,
      required DateTime dueDate,
      required bool complete}) async {
    final authorId = await _getAuthorIdOrNull();
    final realm = await _realm;
    final reminder = ReminderRealmModel(
      _uuid.v4(),
      title,
      dueDate,
      complete,
      authorId: authorId,
    );
    realm.write(() {
      realm.add(reminder);
    });
    return reminder.toReminderModel();
  }

  @override
  Future<void> delete(String id) async {
    final realm = await _realm;
    final reminder = realm.find<ReminderRealmModel>(id);
    if (reminder != null) {
      realm.write(() {
        realm.delete(reminder);
      });
    }
  }

  @override
  Future<ReminderListResponse> getAll(ReminderModelRequest? request) async {
    final authorId = await _getAuthorIdOrNull();
    final realmReminderModels = await getSortQuery(request, authorId);
    final reminderModels = realmReminderModels
        .map((realmModel) => realmModel.toReminderModel())
        .toList();
    return ReminderListResponse(
        items: reminderModels, totalCount: reminderModels.length);
  }

  @override
  Future<ReminderListResponse> getAllDashboard(
      ReminderModelRequest? request) async {
    final authorId = await _getAuthorIdOrNull();
    final realmReminderModels = await getSortQuery(request, authorId);
    final reminderModels = realmReminderModels
        .map((realmModel) => realmModel.toReminderModel())
        .toList();
    return ReminderListResponse(items: reminderModels);
  }

  Future<RealmResults<ReminderRealmModel>> getSortQuery(
      ReminderModelRequest? request, String? authorId) async {
    final realm = await _realm;
    String sort = 'dueDate DESC';
    // Sort the results
    if (request?.sort != null) {
      switch (request?.sort) {
        case ReminderModelRequestSort.dueDateDesc || null:
          sort = 'dueDate DESC';
          break;
        case ReminderModelRequestSort.dueDateAsc:
          sort = 'dueDate ASC';
          break;
      }
    }

    RealmResults<ReminderRealmModel> realmReminderModels =
        realm.query<ReminderRealmModel>(
      'authorId == \$0 SORT($sort)',
      [authorId],
    );

    if (request?.complete != null) {
      realmReminderModels
          .query(r'complete == $0', [request!.complete ?? false]);
    }

    if (request?.filterByDueDateRange != null) {
      realmReminderModels.query(r'dueDate >= $0 AND dueDate <= $1', [
        request!.filterByDueDateRange!.from,
        request.filterByDueDateRange!.to
      ]);
    }

    return realmReminderModels;
  }

  @override
  Future<int> getCompleteCount() async => (await _realm)
      .query<ReminderRealmModel>(r'complete == $0', [true]).length;

  @override
  Future<int> getIncompleteCount() async => (await _realm)
      .query<ReminderRealmModel>(r'complete == $0', [false]).length;

  @override
  Future<ReminderPair> update(ReminderModel updatedModel) async {
    final realm = await _realm;
    final existingReminder = realm.find<ReminderRealmModel>(updatedModel.id);
    if (existingReminder != null) {
      final oldModel = existingReminder.freeze().toReminderModel();
      realm.write(() {
        existingReminder.title = updatedModel.title;
        existingReminder.dueDate = updatedModel.dueDate;
        existingReminder.complete = updatedModel.complete;
      });
      return ReminderPair(
        old: oldModel,
        updated: updatedModel,
      );
    } else {
      throw Exception('Reminder not found');
    }
  }

  Future<String?> _getAuthorIdOrNull() async {
    var user = await _storage.read(key: _authorId);
    if (user == _anonymous) {
      return null;
    }
    return user;
  }
}

extension ReminderModelMapper on ReminderModel {
  ReminderRealmModel toReminderRealmModel() {
    return ReminderRealmModel(
      id,
      title,
      dueDate,
      complete,
      authorId: authorId,
    );
  }
}

extension ReminderRealmModelMapper on ReminderRealmModel {
  ReminderModel toReminderModel() {
    return ReminderModel(
      id: id,
      title: title,
      dueDate: dueDate,
      complete: complete,
      authorId: authorId,
    );
  }
}
