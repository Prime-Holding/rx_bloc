/// Model containing information about the dashboard counters for the complete
/// and incomplete number of reminders
class DashboardCountersModel {
  DashboardCountersModel({
    required this.incompleteCount,
    required this.completeCount,
  });

  /// Number of incomplete reminders
  final int incompleteCount;

  /// Number of complete reminders
  final int completeCount;

  /// Returns a copy of the model with the provided fields replaced with the
  /// new values
  DashboardCountersModel copyWith({
    int? incompleteCount,
    int? completeCount,
  }) =>
      DashboardCountersModel(
        incompleteCount: incompleteCount ?? this.incompleteCount,
        completeCount: completeCount ?? this.completeCount,
      );
}
