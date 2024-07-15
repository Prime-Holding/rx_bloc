import 'reminder_model.dart';

class ReminderPair {
  ReminderPair({required this.updated, required this.old});

  final ReminderModel updated;

  final ReminderModel old;

  factory ReminderPair.fromJson(Map<String, dynamic> json) {
    return ReminderPair(
      updated: ReminderModel.fromJson(json['updated']),
      old: ReminderModel.fromJson(json['old']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'updated': updated.toJson(),
      'old': old.toJson(),
    };
  }
}
