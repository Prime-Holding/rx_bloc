import '../dtos/reminders/objectbox_reminder_dto.dart';
import '../models/reminder/reminder_model.dart';

extension ReminderModelMapper on ReminderModel {
  ObjectBoxLocalReminderDto toReminderObjectboxLocalDto(int id) {
    return ObjectBoxLocalReminderDto(
      id: id,
      title: title,
      dueDate: dueDate,
      complete: complete,
      authorId: authorId,
    );
  }

  ObjectBoxCloudReminderDto toReminderObjectboxCloudDto(int id) {
    return ObjectBoxCloudReminderDto(
      id: id,
      title: title,
      dueDate: dueDate,
      complete: complete,
      authorId: authorId,
    );
  }
}

extension ReminderObjectboxLocalDtoMapper on ObjectBoxLocalReminderDto {
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

extension ReminderObjectboxCloudDtoMapper on ObjectBoxCloudReminderDto {
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
