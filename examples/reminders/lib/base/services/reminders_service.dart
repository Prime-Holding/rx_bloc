import '../models/reminder_model.dart';
import '../repositories/reminders_repository.dart';

class RemindersService {
  RemindersService(this._repository);

  final RemindersRepository _repository;

  Future<List<ReminderModel>> getAll(ReminderModelRequest? request) =>
      _repository.getAll(request);

  Future<ReminderModel> create({
    required String title,
    required DateTime dueDate,
    required bool complete,
  }) =>
      _repository.create(
        title: title,
        dueDate: dueDate,
        complete: complete,
      );

  Future<void> delete(String id) => _repository.delete(id);

  Future<ReminderModel> update(ReminderModel model) =>
      _repository.update(model);

  Future<int> getCompleteCount() => _repository.getCompleteCount();

  Future<int> getIncompleteCount() => _repository.getIncompleteCount();
}
