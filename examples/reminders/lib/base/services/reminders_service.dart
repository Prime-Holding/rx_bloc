import '../models/reminder_model.dart';
import '../repositories/reminders_repository.dart';

class RemindersService {
  RemindersService(this._repository);

  final RemindersRepository _repository;

  Future<List<ReminderModel>> getAll(ReminderModelRequest request) =>
      _repository.getAll(request);

  Future<ReminderModel> create({
    required String title,
    required DateTime dueDate,
  }) =>
      _repository.create(title: title, dueDate: dueDate);

  Future<void> delete(String id) => _repository.delete(id);

  Future<ReminderModel> update(ReminderModel model) =>
      _repository.update(model);
}
