import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../objectbox.g.dart';
import '../../models/reminder/reminder_list_response.dart';
import '../../models/reminder/reminder_model.dart';
import '../remote/reminders_data_source.dart';

class ObjectBox extends RemindersDataSource {
  final Store store;

  final Box<ObjectBoxReminderModel> remindersBox;
  final FlutterSecureStorage _storage;

  static const _authorId = 'authorId';
  static const _anonymous = 'anonymous';

  ObjectBox._init(this.store, this.remindersBox, this._storage) {
    final syncServerIp = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
    final syncClient =
        Sync.client(store, 'ws://$syncServerIp:9999', SyncCredentials.none());
    syncClient.start();
  }

  static Future<ObjectBox> init(FlutterSecureStorage _storage) async {
    final store = await openStore();
    final remindersBox = store.box<ObjectBoxReminderModel>();
    return ObjectBox._init(store, remindersBox, _storage);
  }

  @override
  Future<ReminderModel> create(
      {required String title,
      required DateTime dueDate,
      required bool complete}) async {
    var authorId = await _getAuthorIdOrNull();

    final reminder = ObjectBoxReminderModel(
      title: title,
      dueDate: dueDate,
      complete: complete,
      authorId: authorId,
    );
    remindersBox.put(reminder);
    return reminder;
  }

  @override
  Future<void> delete(String id) async {
    remindersBox.remove(int.parse(id));
  }

  ///Return all reminders from the ObjectBox database
  @override
  Future<ReminderListResponse> getAll(ReminderModelRequest? request) async {
    final authorId = await _getAuthorIdOrNull();

    final result = (remindersBox.query(authorId == null
            ? ObjectBoxReminderModel_.authorId.isNull()
            : ObjectBoxReminderModel_.authorId.equals(authorId)))
        .build()
        .find();
    return ReminderListResponse(items: result, totalCount: 1);
  }

  ///Return only the incomplete reminders that are before the current date
  @override
  Future<ReminderListResponse> getAllDashboard(
      ReminderModelRequest? request) async {
    final authorId = await _getAuthorIdOrNull();

    final result = (remindersBox.query((authorId == null
            ? ObjectBoxReminderModel_.authorId.isNull()
            : ObjectBoxReminderModel_.authorId.equals(authorId))
        .and(ObjectBoxReminderModel_.complete.equals(false))
        .and(ObjectBoxReminderModel_.dueDate.lessThanDate(
          DateTime.now(),
        )))).build().find();
    return ReminderListResponse(items: result);
  }

  @override
  Future<int> getCompleteCount() async =>
      (remindersBox.query(ObjectBoxReminderModel_.complete.equals(true)))
          .build()
          .find()
          .length;

  @override
  Future<int> getIncompleteCount() async =>
      (remindersBox.query(ObjectBoxReminderModel_.complete.equals(false)))
          .build()
          .find()
          .length;

  @override
  Future<ReminderPair> update(ReminderModel updatedModel) async {
    var oldModel = remindersBox.get(int.parse(updatedModel.id));
    final newModel = remindersBox.put(
      ObjectBoxReminderModel(
          index: int.parse(updatedModel.id),
          title: updatedModel.title,
          dueDate: updatedModel.dueDate,
          complete: updatedModel.complete,
          authorId: updatedModel.authorId),
    );
    return ReminderPair(
      old: ObjectBoxReminderModel(
        index: newModel,
        title: oldModel?.title ?? '',
        dueDate: oldModel?.dueDate ?? DateTime.now(),
        complete: oldModel?.complete ?? false,
        authorId: oldModel?.authorId,
      ),
      updated: ObjectBoxReminderModel(
          index: newModel,
          title: updatedModel.title,
          dueDate: updatedModel.dueDate,
          complete: updatedModel.complete,
          authorId: updatedModel.authorId),
    );
  }

  /// Returns the id of the logged in user or null if no user is logged in
  Future<String?> _getAuthorIdOrNull() async {
    var user = await _storage.read(key: _authorId);
    if (user == _anonymous) {
      return null;
    }
    return user;
  }
}
