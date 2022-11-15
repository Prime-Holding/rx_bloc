part of 'dashboard_bloc.dart';

/// Here you can add the implementation details of your BloC or any stream extensions you might need.
/// Thus, the BloC will contain only declarations, which improves the readability and the maintainability.
extension _DashboardExtension on DashboardBloc {}

extension _ToError on Stream<Exception> {
  Stream<String> toMessage() => map((errorState) => errorState.toString());
}

extension ResultStreamExtensions on Stream<Result<DashboardCountersModel>> {
  Future<void> waitToLoad() async {
    await firstWhere((resultModel) => resultModel is ResultLoading);
    await firstWhere((resultModel) => resultModel is! ResultLoading);
  }
}

extension DashboardBlocStreamExtensions on Stream<bool> {
  Stream<Result<DashboardCountersModel>> fetchDashboardData(
    DashboardService dashboardService,
  ) =>
      switchMap(
        (_) => dashboardService.getDashboardModel().asResultStream(),
      );

  /// Fetches appropriate data from the repository
  Stream<Result<PaginatedList<ReminderModel>>> fetchReminderModels(
    DashboardService service,
    BehaviorSubject<PaginatedList<ReminderModel>> paginatedList,
  ) =>
      distinct().throttleTime(const Duration(milliseconds: 200)).switchMap(
        (reset) {
          if (reset) {
            paginatedList.value.reset();
          }

          return service.getDashboardPaginated(paginatedList).asResultStream();
        },
      );
}
