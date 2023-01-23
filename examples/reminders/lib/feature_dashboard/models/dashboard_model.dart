class DashboardCountersModel {
  DashboardCountersModel({
    required this.incompleteCount,
    required this.completeCount,
  });

  final int incompleteCount;
  final int completeCount;

  DashboardCountersModel copyWith({
    int? incompleteCount,
    int? completeCount,
  }) =>
      DashboardCountersModel(
        incompleteCount: incompleteCount ?? this.incompleteCount,
        completeCount: completeCount ?? this.completeCount,
      );
}
