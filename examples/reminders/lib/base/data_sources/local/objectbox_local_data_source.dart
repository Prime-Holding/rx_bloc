import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../objectbox.g.dart';

import '../../models/reminder/objectbox_reminder_model.dart';
import '../../models/reminder/reminder_list_response.dart';
import '../../models/reminder/reminder_model.dart';
import '../remote/reminders_data_source.dart';

class ObjectBoxLocal extends RemindersDataSource {
  final Store _store;

  late final Box<ObjectBoxLocalReminderModel> _remindersBox;
  final FlutterSecureStorage _storage;

  static const _authorId = 'authorId';
  static const _anonymous = 'anonymous';

  ObjectBoxLocal._initLocal(this._store, this._storage) {
    _remindersBox = Box<ObjectBoxLocalReminderModel>(_store);
  }

  static Future<ObjectBoxLocal> init(FlutterSecureStorage storage) async {
    final store = await openStore();

    return ObjectBoxLocal._initLocal(store, storage);
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
    try {
      _remindersBox.put(reminder);
    } catch (e) {
      print(e);
    }

    return reminder;
  }

  @override
  Future<void> delete(String id) async {
    _remindersBox.remove(int.parse(id));
  }

  ///Return all reminders from the ObjectBox database
  @override
  Future<ReminderListResponse> getAll(ReminderModelRequest? request) async {
    final authorId = await _getAuthorIdOrNull();
    final result = _remindersBox
        .query(getCondition(request, authorId))
        .order(ObjectBoxLocalReminderModel_.dueDate,
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
    final result = _remindersBox
        .query(getCondition(request, authorId))
        .order(ObjectBoxLocalReminderModel_.authorId,
            flags: getOrder(request?.sort))
        .build()
        .find();
    return ReminderListResponse(items: result);
  }

  @override
  Future<int> getCompleteCount() async =>
      (_remindersBox.query(ObjectBoxLocalReminderModel_.complete.equals(true)))
          .build()
          .find()
          .length;

  @override
  Future<int> getIncompleteCount() async =>
      (_remindersBox.query(ObjectBoxLocalReminderModel_.complete.equals(false)))
          .build()
          .find()
          .length;

  @override
  Future<ReminderPair> update(ReminderModel updatedModel) async {
    var oldModel = _remindersBox.get(int.parse(updatedModel.id));
    final newModel = _remindersBox.put(
      ObjectBoxLocalReminderModel(
          index: int.parse(updatedModel.id),
          title: updatedModel.title,
          dueDate: updatedModel.dueDate,
          complete: updatedModel.complete,
          authorId: updatedModel.authorId),
    );
    return ReminderPair(
      old: ObjectBoxLocalReminderModel(
        index: newModel,
        title: oldModel?.title ?? '',
        dueDate: oldModel?.dueDate ?? DateTime.now(),
        complete: oldModel?.complete ?? false,
        authorId: oldModel?.authorId,
      ),
      updated: ObjectBoxLocalReminderModel(
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
