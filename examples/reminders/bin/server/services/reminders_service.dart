import '../models/reminder_model.dart';
import '../models/reminder_pair_model.dart';
import '../repositories/reminders_repository.dart';

class RemindersService {
  final RemindersRepository remindersRepository;
  RemindersService(this.remindersRepository);

  int getCompleteCount() => remindersRepository.getCompleteCount();

  int getIncompleteCount() => remindersRepository.getIncompleteCount();

  ReminderList getAllDashboardReminders(Map<String, dynamic> params) {
    final authorId = params['authorId'];
    return remindersRepository.getAllDashboard(authorId);
  }

  ReminderList getAllReminders(Map<String, dynamic> params) {
    final authorId = params['authorId'];
    return remindersRepository.getAllReminders(authorId);
  }

  ReminderModel createReminder(String title, DateTime dueDate, bool complete) {
    return remindersRepository.addReminder(null, title, dueDate, complete);
  }

  void deleteReminder(int id) {
    remindersRepository.removeReminder(id);
  }

  ReminderPair updateReminder(int id, Map<String, dynamic> params) =>
      remindersRepository.updateReminder(id, params);
}
