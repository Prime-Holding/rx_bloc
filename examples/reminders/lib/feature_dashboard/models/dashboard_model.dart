class DashboardModel {
  DashboardModel({
    required this.incompleteCount,
    required this.completeCount,
  });

  final int incompleteCount;
  final int completeCount;

  DashboardModel copyWith({
    int? incompleteCount,
    int? completeCount,
  }) =>
      DashboardModel(
        incompleteCount: incompleteCount ?? this.incompleteCount,
        completeCount: completeCount ?? this.completeCount,
      );
}
