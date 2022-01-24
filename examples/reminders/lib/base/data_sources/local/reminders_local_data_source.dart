import '../../models/reminder_model.dart';

class RemindersLocalDataSource {
  RemindersLocalDataSource({List<ReminderModel>? seed})
      : _data = seed ??
            List.generate(
              1000,
              (index) => ReminderModel.fromIndex(index),
            );

  final List<ReminderModel> _data;

  Future<List<ReminderModel>> getAll(ReminderModelRequest request) async {
    await Future.delayed(const Duration(milliseconds: 200));

    var data = [..._data];

    data.sortByDueDate(request.sort);

    data = data
      ..whereInRange(request.filterByDueDateRange)
      ..whereInPage(request.page, request.pageSize);

    return data;
  }

  Future<ReminderModel> create({
    required String title,
    required DateTime dueDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final id = (_data.indexOf(_data.last) + 1).toString();
    final reminder = ReminderModel(dueDate: dueDate, id: id, title: title);

    _data.add(reminder);

    return reminder;
  }

  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    _data.removeWhere((element) => element.id == id);
  }

  Future<ReminderModel> update(ReminderModel model) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _data.indexWhere((element) => element.id == model.id);

    var _model = _data[index].copyWith(
      title: model.title,
      dueDate: model.dueDate,
    );

    _data[index] = _model;

    return _model;
  }
}

extension _ListReminderModelX on List<ReminderModel> {
  List<ReminderModel> whereInPage(int page, int pageSize) {
    final start = (page - 1) * pageSize;
    final end = start + pageSize;

    return getRange(start, end).toList();
  }

  List<ReminderModel> whereInRange(DueDateRange? filter) {
    if (filter != null) {
      return where(
        (model) =>
            model.dueDate.isAfter(filter.from) &&
            model.dueDate.isBefore(filter.to),
      ).toList();
    }

    return this;
  }

  void sortByDueDate(ReminderModelRequestSort? sort) {
    if (sort != null) {
      switch (sort) {
        case ReminderModelRequestSort.dueDateDesc:
          this.sort((a, b) => a.dueDate.compareTo(b.dueDate));
          break;
        case ReminderModelRequestSort.dueDateAsc:
          this.sort((a, b) => b.dueDate.compareTo(a.dueDate));
          break;
      }
    }
  }
}
