import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:realm/realm.dart';
import 'package:uuid/uuid.dart' as uuid;

import '../../models/reminder/reminder_list_response.dart';
import '../../models/reminder/reminder_model.dart';
import '../../models/reminder/reminder_realm_model.dart';
import '../remote/reminders_data_source.dart';

class RealmRemindersDataSource extends RemindersDataSource {
  final Realm _realm;
  final uuid.Uuid _uuid;
  final FlutterSecureStorage _storage;

  static const _authorId = 'authorId';
  static const _anonymous = 'anonymous';

  RealmRemindersDataSource(this._realm, this._uuid, this._storage);

  @override
  Future<ReminderModel> create(
      {required String title,
      required DateTime dueDate,
      required bool complete}) async {
    final authorId = await _getAuthorIdOrNull();
    final reminder = ReminderRealmModel(
      _uuid.v4(),
      title,
      dueDate,
      complete,
      authorId: authorId,
    );
    _realm.write(() {
      _realm.add(reminder);
    });
    return reminder.toReminderModel();
  }

  @override
  Future<void> delete(String id) async {
    final reminder = _realm.find<ReminderRealmModel>(id);
    if (reminder != null) {
      _realm.write(() {
        _realm.delete(reminder);
      });
    }
  }

  @override
  Future<ReminderListResponse> getAll(ReminderModelRequest? request) async {
    final authorId = await _getAuthorIdOrNull();
    final realmReminderModels = _realm.query<ReminderRealmModel>(
      getSortQuery(request, authorId),
    );
    if (request?.filterByDueDateRange != null) {
      realmReminderModels.query(r'dueDate >= $0 AND dueDate <= $1', [
        request!.filterByDueDateRange!.from,
        request.filterByDueDateRange!.to
      ]);
    }
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
    final realmReminderModels = _realm.query<ReminderRealmModel>(
      getSortQuery(request, authorId),
    );
    if (request?.filterByDueDateRange != null) {
      realmReminderModels.query(r'dueDate >= $0 AND dueDate <= $1', [
        request!.filterByDueDateRange!.from,
        request.filterByDueDateRange!.to
      ]);
    }
    final reminderModels = realmReminderModels
        .map((realmModel) => realmModel.toReminderModel())
        .toList();
    return ReminderListResponse(items: reminderModels);
  }

  String getSortQuery(ReminderModelRequest? request, String? authorId) {
    // Base query string for authorId
    String query = 'authorId == $authorId';

    // Filter by completion status if provided
    if (request?.complete != null) {
      query += ' AND complete == ${request?.complete}';
    }

    // Sort the results
    String sort = '';
    if (request?.sort != null) {
      switch (request?.sort) {
        case ReminderModelRequestSort.dueDateDesc:
          sort = 'dueDate DESC';
          break;
        case ReminderModelRequestSort.dueDateAsc:
          sort = 'dueDate ASC';
          break;
        case null:
          sort = 'dueDate DESC';
      }
    }

    // Append sorting to query
    if (sort.isNotEmpty) {
      query += ' SORT($sort)';
    }

    return query;
  }

  @override
  Future<int> getCompleteCount() async =>
      _realm.query<ReminderRealmModel>(r'complete == $0', [true]).length;

  @override
  Future<int> getIncompleteCount() async =>
      _realm.query<ReminderRealmModel>(r'complete == $0', [false]).length;

  @override
  Future<ReminderPair> update(ReminderModel updatedModel) async {
    final existingReminder = _realm.find<ReminderRealmModel>(updatedModel.id);
    if (existingReminder != null) {
      final oldModel = existingReminder.freeze().toReminderModel();
      _realm.write(() {
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
