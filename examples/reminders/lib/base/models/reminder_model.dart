class ReminderModel {
  ReminderModel({
    required this.id,
    required this.title,
    required this.dueDate,
  });

  final String id;
  final String title;
  final DateTime dueDate;

  factory ReminderModel.fromIndex(int index) => ReminderModel(
        id: index.toString(),
        title: 'Reminder $index',
        dueDate: DateTime.now().add(
          Duration(days: index),
        ),
      );
}
