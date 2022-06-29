import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModelFirebaseRequestData {
  ReminderModelFirebaseRequestData({
    required this.title,
    required this.dueDate,
    required this.complete,
  });

  final String title;
  final Timestamp dueDate;
  final bool complete;

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'dueDate': dueDate,
      'complete': complete,
    };
  }
}