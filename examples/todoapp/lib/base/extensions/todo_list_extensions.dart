import 'package:collection/collection.dart';

import '../models/todo_model.dart';

extension TodoListExtensions on List<$TodoModel> {
  /// Sorts the list by the [createdAt] field in descending order.
  List<$TodoModel> sortByCreatedAt() =>
      sorted((todo1, todo2) => todo2.createdAt.compareTo(todo1.createdAt));
}
