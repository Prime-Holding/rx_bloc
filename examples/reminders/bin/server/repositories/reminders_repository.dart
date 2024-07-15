// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../models/reminder_model.dart';
import '../models/reminder_pair_model.dart';

class RemindersRepository {
  final List<ReminderModel> _reminders = [];
  int id = 0;

  int getCompleteCount() =>
      _reminders.where((reminder) => reminder.complete).toList().length;

  int getIncompleteCount() =>
      _reminders.where((reminder) => !reminder.complete).toList().length;

  ReminderList getAllDashboard(String? authorId) {
    return ReminderList(
        items: _reminders
            .where((reminder) => reminder.authorId == authorId)
            .toList(),
        count: getRemindersCount(authorId));
  }

  ReminderModel addReminder(
      String? authorId, String title, DateTime dueDate, bool complete) {
    id++;
    final newReminder = ReminderModel(
        id: id,
        title: title,
        dueDate: dueDate,
        complete: complete,
        authorId: authorId);
    _reminders.add(newReminder);

    return newReminder;
  }

  int getRemindersCount(String? authorId) => _reminders
      .where((reminder) => reminder.authorId == authorId)
      .toList()
      .length;

  void removeReminder(int index) {
    _reminders.removeWhere((reminder) => reminder.id == index);
  }

  ReminderPair updateReminder(int id, Map<String, dynamic> params) {
    final index = _reminders.indexWhere((reminder) => reminder.id == id);
    if (index != -1) {
      _reminders[index].title = params['title'];
      _reminders[index].dueDate = DateTime.parse(params['dueDate']);
      _reminders[index].complete = params['complete'];
    }
    return ReminderPair(old: _reminders[index], updated: _reminders[index]);
  }

  ReminderList getAllReminders(String? authorId) => ReminderList(
      items: _reminders
          .where((reminder) => reminder.authorId == authorId)
          .toList(),
      count: getRemindersCount(authorId));
}
