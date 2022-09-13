part of 'dashboard_bloc.dart';

/// Here you can add the implementation details of your BloC or any stream extensions you might need.
/// Thus, the BloC will contain only declarations, which improves the readability and the maintainability.
extension _DashboardExtension on DashboardBloc {}

extension _ToError on Stream<Exception> {
  Stream<String> toMessage() => map((errorState) => errorState.toString());
}

extension ResultStreamExtensions on Stream<Result<DashboardModel>> {
  Future<void> waitToLoad() async {
    await firstWhere((resultModel) => resultModel is ResultLoading);
    await firstWhere((resultModel) => resultModel is! ResultLoading);
  }
}

extension DashboardBlocStreamExtensions on Stream<bool> {
  Stream<Result<DashboardModel>> fetchDashboardData(
    DashboardService _dashboardService,
  ) =>
      switchMap(
        (_) => _dashboardService.getDashboardModel().asResultStream(),
      );

  /// Fetches appropriate data from the repository
  Stream<Result<PaginatedList<ReminderModel>>> fetchReminderModels(
    DashboardService _service,
    BehaviorSubject<PaginatedList<ReminderModel>> _paginatedList,
  ) =>
      distinct().throttleTime(const Duration(milliseconds: 200)).switchMap(
        (reset) {
          if (reset) {
            _paginatedList.value.reset();
          }

          return _service
              .getDashboardPaginated(_paginatedList)
              .asResultStream();
        },
      );
}