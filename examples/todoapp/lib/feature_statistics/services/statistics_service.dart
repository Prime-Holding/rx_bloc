import '../../base/models/todo_model.dart';
import '../models/todo_stats_model.dart';

class StatisticsService {
  /// Calculates the statistics of the todos.
  ///
  /// The statistics include the number of completed and incomplete todos.
  TodoStatsModel calculateStats(List<TodoModel> todoList) => TodoStatsModel(
        completed: todoList.where((todo) => todo.completed).length,
        incomplete: todoList.where((todo) => !todo.completed).length,
      );
}
