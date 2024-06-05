import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../objectbox.g.dart';

import '../../app/config/environment_config.dart';
import '../../models/reminder/objectbox_reminder_model.dart';
import '../../models/reminder/reminder_list_response.dart';
import '../../models/reminder/reminder_model.dart';
import '../remote/reminders_data_source.dart';

class ObjectboxCloud extends RemindersDataSource {
  final Future<Box<ObjectBoxCloudReminderModel>> _remindersBox;
  final FlutterSecureStorage _storage;

  static const _authorId = 'authorId';
  static const _anonymous = 'anonymous';

  static ObjectboxCloud? _instance;

  ObjectboxCloud._init(this._storage, this._remindersBox);

  static ObjectboxCloud getInstance(
    FlutterSecureStorage storage,
    EnvironmentConfig env,
  ) {
    if (_instance == null) {
      final store = openStore();
      final remindersBox = _initCloud(env, store);
      _instance = ObjectboxCloud._init(storage, remindersBox);
    }
    return _instance!;
  }

  static Future<Box<ObjectBoxCloudReminderModel>> _initCloud(
      EnvironmentConfig config, Future<Store> openStore) async {
    var store = await openStore;
    var reminderBox = store.box<ObjectBoxCloudReminderModel>();
    //TODO: Add sync client IP
    final syncServerIp = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
    final syncClient =
        Sync.client(store, 'ws://$syncServerIp:9999', SyncCredentials.none());
    syncClient.start();

    return reminderBox;
  }

  @override
  Future<ReminderModel> create(
      {required String title,
      required DateTime dueDate,
      required bool complete}) async {
    var authorId = await _getAuthorIdOrNull();

    final reminder = ObjectBoxCloudReminderModel(
      title: title,
      dueDate: dueDate,
      complete: complete,
      authorId: authorId,
    );
    (await _remindersBox).put(reminder);

    return reminder;
  }

  @override
  Future<void> delete(String id) async {
    (await _remindersBox).remove(int.parse(id));
  }

  ///Return all reminders from the ObjectBox database
  @override
  Future<ReminderListResponse> getAll(ReminderModelRequest? request) async {
    final authorId = await _getAuthorIdOrNull();
    final result = (await _remindersBox)
        .query(getCondition(request, authorId))
        .order(ObjectBoxCloudReminderModel_.dueDate,
            flags: getOrder(request?.sort))
        .build()
        .find();
    return ReminderListResponse(items: result, totalCount: result.length);
  }

  ///Return only the incomplete reminders that are before the current date
  @override
  Future<ReminderListResponse> getAllDashboard(
      ReminderModelRequest? request) async {
    final authorId = await _getAuthorIdOrNull();
    final result = (await _remindersBox)
        .query(getCondition(request, authorId))
        .order(ObjectBoxCloudReminderModel_.authorId,
            flags: getOrder(request?.sort))
        .build()
        .find();
    return ReminderListResponse(items: result);
  }

  @override
  Future<int> getCompleteCount() async => (await _remindersBox)
      .query(ObjectBoxCloudReminderModel_.complete.equals(true))
      .build()
      .find()
      .length;

  @override
  Future<int> getIncompleteCount() async => (await _remindersBox)
      .query(ObjectBoxCloudReminderModel_.complete.equals(false))
      .build()
      .find()
      .length;

  @override
  Future<ReminderPair> update(ReminderModel updatedModel) async {
    var oldModel = (await _remindersBox).get(int.parse(updatedModel.id));
    final newModel = (await _remindersBox).put(
      ObjectBoxCloudReminderModel(
          index: int.parse(updatedModel.id),
          title: updatedModel.title,
          dueDate: updatedModel.dueDate,
          complete: updatedModel.complete,
          authorId: updatedModel.authorId),
    );
    return ReminderPair(
      old: ObjectBoxCloudReminderModel(
        index: newModel,
        title: oldModel?.title ?? '',
        dueDate: oldModel?.dueDate ?? DateTime.now(),
        complete: oldModel?.complete ?? false,
        authorId: oldModel?.authorId,
      ),
      updated: ObjectBoxCloudReminderModel(
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

  Condition<ObjectBoxCloudReminderModel> getCondition(
      ReminderModelRequest? request, String? authorId) {
    Condition<ObjectBoxCloudReminderModel>? condition;
    DateTime from;
    DateTime to;

    if (request?.filterByDueDateRange != null) {
      from = request?.filterByDueDateRange?.from ?? DateTime.now();
      to = request?.filterByDueDateRange?.to ?? DateTime.now();
    } else {
      from = DateTime.now().subtract(const Duration(days: 365));
      to = DateTime.now().add(const Duration(days: 365));
    }
    condition = ((authorId == null
        ? ObjectBoxCloudReminderModel_.authorId.isNull()
        : ObjectBoxCloudReminderModel_.authorId.equals(authorId)));
    if (request?.complete != null) {
      condition.and(
          ObjectBoxCloudReminderModel_.complete.equals(request!.complete!));
    }

    condition.and(ObjectBoxCloudReminderModel_.dueDate.betweenDate(from, to));
    return condition;
  }

  int getOrder(ReminderModelRequestSort? sort) {
    int order = 0;
    if (sort != null) {
      switch (sort) {
        case ReminderModelRequestSort.dueDateAsc:
          break;
        case ReminderModelRequestSort.dueDateDesc:
          order = Order.descending;
      }
    }
    return order;
  }
}