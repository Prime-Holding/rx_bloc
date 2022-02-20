import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../models/dashboard_model.dart';
import '../services/dashboard_service.dart';

part 'dashboard_bloc.rxb.g.dart';
part 'dashboard_bloc_extensions.dart';

/// A contract class containing all events of the DashboardBloC.
abstract class DashboardBlocEvents {
  /// TODO: Document the event
  void fetchData();
}

/// A contract class containing all states of the DashboardBloC.
abstract class DashboardBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;

  /// TODO: Document the state
  Stream<Result<DashboardModel>> get data;
}

@RxBloc()
class DashboardBloc extends $DashboardBloc {
  DashboardBloc(this._dashboardService, CoordinatorBlocType coordinatorBloc) {
    _$fetchDataEvent
        .startWith(null)
        .switchMap(
            (value) => _dashboardService.getDashboardModel().asResultStream())
        .setResultStateHandler(this)
        .bind(_dashboardModelResult)
        .addTo(_compositeSubscription);

    coordinatorBloc
        .mapReminderManageEventsWithLatestFrom(
          _dashboardModelResult
              .whereSuccess()
              .map((dashboard) => dashboard.reminderList),
          operationCallback: _dashboardService.getManageOperation,
        )
        .map(managedListToDashboard)
        .mapResult(_dashboardService.sortedReminderList)
        .bind(_dashboardModelResult)
        .addTo(_compositeSubscription);
  }

  final DashboardService _dashboardService;

  Result<DashboardModel> managedListToDashboard(
    ManagedList<ReminderModel> managedList,
  ) {
    final dashboard = _dashboardModelResult.value;

    if (dashboard is ResultSuccess<DashboardModel>) {
      return Result.success(
        _dashboardService.getDashboardModelFromManagedList(
          dashboard: dashboard.data,
          managedList: managedList,
        ),
      );
    }

    return dashboard;
  }

  @override
  Stream<Result<DashboardModel>> _mapToDataState() => _dashboardModelResult;

  final _dashboardModelResult =
      BehaviorSubject<Result<DashboardModel>>.seeded(Result.loading());

  @override
  Stream<String> _mapToErrorsState() => errorState.toMessage();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  void dispose() {
    _dashboardModelResult.close();
    super.dispose();
  }
}
