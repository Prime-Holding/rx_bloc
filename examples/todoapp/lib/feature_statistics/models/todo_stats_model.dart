class TodoStatsModel {
  /// The number of completed todos.
  final int completed;

  /// The number of incomplete todos.
  final int incomplete;

  TodoStatsModel({
    required this.completed,
    required this.incomplete,
  });
}
