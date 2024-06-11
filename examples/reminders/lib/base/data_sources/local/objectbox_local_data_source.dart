import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../objectbox.g.dart';

import '../../app/config/environment_config.dart';
import '../../models/reminder/objectbox_reminder_model.dart';
import '../../models/reminder/reminder_list_response.dart';
import '../../models/reminder/reminder_model.dart';
import '../remote/reminders_data_source.dart';

class ObjectBoxLocal extends RemindersDataSource {
  final Future<Box<ObjectBoxLocalReminderModel>> _remindersBox;
  final FlutterSecureStorage _storage;

  static const _authorId = 'authorId';
  static const _anonymous = 'anonymous';

  static ObjectBoxLocal? _instance;

  ObjectBoxLocal._init(this._storage, this._remindersBox);

  static ObjectBoxLocal getInstance(
    FlutterSecureStorage storage,
    EnvironmentConfig env,
  ) {
    if (_instance == null) {
      final store = openStore();
      final remindersBox = _initCloud(env, store);
      _instance = ObjectBoxLocal._init(storage, remindersBox);
    }
    return _instance!;
  }

  static Future<Box<ObjectBoxLocalReminderModel>> _initCloud(
      EnvironmentConfig config, Future<Store> openStore) async {
    var store = await openStore;
    var reminderBox = store.box<ObjectBoxLocalReminderModel>();

    return reminderBox;
  }

  @override
  Future<ReminderModel> create(
      {required String title,
      required DateTime dueDate,
      required bool complete}) async {
    var authorId = await _getAuthorIdOrNull();

    final reminder = ObjectBoxLocalReminderModel(
      title: title,
      dueDate: dueDate,
      complete: complete,
      authorId: authorId,
    );

    (await _remindersBox).put(reminder);
    return reminder.toReminderModel();
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
        .order(ObjectBoxLocalReminderModel_.dueDate,
            flags: getOrder(request?.sort))
        .build()
        .find();
    final items = result.map((e) => e.toReminderModel()).toList();
    return ReminderListResponse(items: items, totalCount: result.length);
  }

  ///Return only the incomplete reminders that are before the current date
  @override
  Future<ReminderListResponse> getAllDashboard(
      ReminderModelRequest? request) async {
    final authorId = await _getAuthorIdOrNull();
    final result = (await _remindersBox)
        .query(getCondition(request, authorId))
        .order(ObjectBoxLocalReminderModel_.authorId,
            flags: getOrder(request?.sort))
        .build()
        .find();
    final items = result.map((e) => e.toReminderModel()).toList();
    return ReminderListResponse(items: items);
  }

  @override
  Future<int> getCompleteCount() async => (await _remindersBox)
      .query(ObjectBoxLocalReminderModel_.complete.equals(true))
      .build()
      .find()
      .length;

  @override
  Future<int> getIncompleteCount() async => (await _remindersBox)
      .query(ObjectBoxLocalReminderModel_.complete.equals(false))
      .build()
      .find()
      .length;

  @override
  Future<ReminderPair> update(ReminderModel updatedModel) async {
    var oldModel = (await _remindersBox).get(int.parse(updatedModel.id));
    if (oldModel == null) {
      throw Exception('Old model not found');
    }
    final oldModelId = int.tryParse(updatedModel.id);
    if (oldModelId == null) {
      throw Exception('Old model id is not a number');
    }
    (await _remindersBox).put(updatedModel.toReminderObjectboxLocalModel(
      oldModelId,
      updatedModel.title,
      updatedModel.dueDate,
      updatedModel.complete,
      updatedModel.authorId,
    ));

    return ReminderPair(
      old: oldModel.toReminderModel(),
      updated: updatedModel,
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

  Condition<ObjectBoxLocalReminderModel> getCondition(
      ReminderModelRequest? request, String? authorId) {
    Condition<ObjectBoxLocalReminderModel>? condition;
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
        ? ObjectBoxLocalReminderModel_.authorId.isNull()
        : ObjectBoxLocalReminderModel_.authorId.equals(authorId)));
    if (request?.complete != null) {
      condition.and(
          ObjectBoxLocalReminderModel_.complete.equals(request!.complete!));
    }

    condition.and(ObjectBoxLocalReminderModel_.dueDate.betweenDate(from, to));
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

extension ReminderModelMapper on ReminderModel {
  ObjectBoxLocalReminderModel toReminderObjectboxLocalModel(
      int id, String title, DateTime dueDate, bool complete, String? authorId) {
    return ObjectBoxLocalReminderModel(
      id: id,
      title: title,
      dueDate: dueDate,
      complete: complete,
      authorId: authorId,
    );
  }
}

extension ReminderRealmModelMapper on ObjectBoxLocalReminderModel {
  ReminderModel toReminderModel() {
    return ReminderModel(
      id: id.toString(),
      title: title,
      dueDate: dueDate,
      complete: complete,
      authorId: authorId,
    );
  }
}
