import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:realm/realm.dart';
import 'package:uuid/uuid.dart' as uuid;

import '../models/reminder/reminder_list_response.dart';
import '../models/reminder/reminder_model.dart';
import '../models/reminder/reminder_realm_model.dart';
import 'remote/reminders_data_source.dart';

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
    final realmReminderModels = _realm.all<ReminderRealmModel>().toList();
    final reminderModels = realmReminderModels
        .map((realmModel) => realmModel.toReminderModel())
        .toList();
    return ReminderListResponse(items: reminderModels);
  }

  @override
  Future<ReminderListResponse> getAllDashboard(
      ReminderModelRequest? request) async {
    final realmReminderModels = _realm.all<ReminderRealmModel>().toList();
    final reminderModels = realmReminderModels
        .map((realmModel) => realmModel.toReminderModel())
        .toList();
    return ReminderListResponse(items: reminderModels);
  }

  @override
  Future<int> getCompleteCount() async {
    final completeReminders =
        _realm.query<ReminderRealmModel>(r'complete == $0', [true]);
    // Return the count of complete reminders
    return completeReminders.length;
  }

  @override
  Future<int> getIncompleteCount() async {
    // final completeReminders =
    //     _realm.query<ReminderRealmModel>(r'complete == $0', [false]);
    final completeReminders =
        _realm.query<ReminderRealmModel>('complete == false');

    final reminderModels = completeReminders
        .map((realmModel) => realmModel.toReminderModel())
        .toList();
    // Return the count of complete reminders
    return reminderModels.length;
  }

  @override
  Future<ReminderPair> update(ReminderModel updatedModel) async {
    final existingReminder = _realm.find<ReminderRealmModel>(updatedModel.id);
    final copy = existingReminder;
    print('jovanCopy + ${copy!.toReminderModel().toJson()}');
    if (existingReminder != null) {
      try {
        _realm.write(() {
          existingReminder.title = updatedModel.title;
          existingReminder.dueDate = updatedModel.dueDate;
          existingReminder.complete = updatedModel.complete;
        });
        print('jovanUpdated +${updatedModel.toJson()}');
        print('jovanCopy + ${copy!.toReminderModel().toJson()}');
      } catch (e) {
        print('jovan + $e');
      }
      return ReminderPair(
        old: existingReminder.toReminderModel(),
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
  ReminderRealmModel toReminderRealmModel(String id, String title,
      DateTime dueDate, bool complete, String? authorId) {
    return ReminderRealmModel(id, title, dueDate, complete, authorId: authorId);
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
