class ReminderList {
  final List<ReminderModel> items;
  final int count;

  ReminderList({
    required this.items,
    required this.count,
  });

  factory ReminderList.fromJson(Map<String, dynamic> json) {
    return ReminderList(
      items: List<ReminderModel>.from(
        json['items'].map((reminder) => ReminderModel.fromJson(reminder)),
      ),
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((reminder) => reminder.toJson()).toList(),
      'count': count,
    };
  }
}

class ReminderModel {
  final int id;
  String title;
  DateTime dueDate;
  bool complete;
  String? authorId;

  ReminderModel({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.complete,
    this.authorId,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'],
      title: json['title'],
      dueDate: DateTime.parse(json['dueDate']),
      complete: json['complete'],
      authorId: json['authorId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'complete': complete,
      'authorId': authorId,
    };
  }
}
