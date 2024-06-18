import 'package:todoapp/base/models/errors/error_model.dart';
import 'package:todoapp/base/models/todo_model.dart';

class Stubs {
  static final todoUncompleted = TodoModel.empty().copyWith(
    id: '1',
    title: 'test title',
    description: 'test description',
    completed: false,
  );

  static final todoUncompletedUpdated = todoUncompleted.copyWith(title: 'new');

  static final todoCompleted = TodoModel.empty().copyWith(
    id: '1',
    title: 'test title',
    description: 'test description',
    completed: true,
  );

  static final todoEmpty = TodoModel.empty();

  static final notFoundError = NotFoundErrorModel();
}
