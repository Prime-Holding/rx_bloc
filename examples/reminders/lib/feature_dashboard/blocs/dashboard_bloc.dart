import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/models/counter/increment_operation.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../../base/models/updated_counters.dart';
import '../models/dashboard_model.dart';
import '../services/dashboard_service.dart';

part 'dashboard_bloc.rxb.g.dart';

part 'dashboard_bloc_extensions.dart';

/// A contract class containing all events of the DashboardBloC.
abstract class DashboardBlocEvents {
  /// TODO: Document the event
  void fetchData({required bool silently});
}

/// A contract class containing all states of the DashboardBloC.
abstract class DashboardBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;

  /// TODO: Document the state
  Stream<Result<DashboardModel>> get data;

  /// Returns when the data refreshing has completed
  @RxBlocIgnoreState()
  Future<void> get refreshDone;
}

@RxBloc()
class DashboardBloc extends $DashboardBloc {
  DashboardBloc(this._dashboardService, this._coordinatorBloc) {
    _$fetchDataEvent
        .startWith(false)
        .switchMap((silently) => _dashboardService
            .getDashboardModel()
            .asResultStream(tag: silently ? _tagSilently : ''))
        .setResultStateHandler(this)
        .bind(_dashboardModelResult)
        .addTo(_compositeSubscription);

    _coordinatorBloc
        .mapReminderManageEventsWithLatestFrom(
          _dashboardModelResult
              .whereSuccess()
              .map((dashboard) => dashboard.reminderList),
          operationCallback: _dashboardService.getManageOperation,
        )
        .map(managedListToDashboard)
        .mapResult(_dashboardService.sortedReminderList)
        .doOnData((event) {
          if (event is ResultSuccess<DashboardModel>) {
            final updatedCounters = UpdatedCounters(
              incomplete: event.data.incompleteCount,
              complete: event.data.completeCount,
            );
            /// If the firebase data source is used, the UpdatedCounters should
            /// be sent to the CoordinatorBloc
            _coordinatorBloc.events.updateCounters(updatedCounters);
          }
        })
        .bind(_dashboardModelResult)
        .addTo(_compositeSubscription);
  }

  final DashboardService _dashboardService;
  final CoordinatorBlocType _coordinatorBloc;

  static const _tagSilently = 'silently';

  Result<DashboardModel> managedListToDashboard(
    ManagedListCounterOperation managedListCounterOperation,
  ) {
    final dashboard = _dashboardModelResult.value;

    if (dashboard is ResultSuccess<DashboardModel>) {
      return Result.success(
        _dashboardService.getDashboardModelFromManagedList(
          dashboard: dashboard.data,
          managedList: managedListCounterOperation.managedList
              as ManagedList<ReminderModel>,
          counterOperation: managedListCounterOperation.counterOperation,
        ),
      );
    }

    return dashboard;
  }

  @override
  Stream<Result<DashboardModel>> _mapToDataState() =>
      _dashboardModelResult.where((resultModel) =>
          !(resultModel is ResultLoading && resultModel.tag == _tagSilently));

  final _dashboardModelResult =
      BehaviorSubject<Result<DashboardModel>>.seeded(Result.loading());

  @override
  Future<void> get refreshDone => _dashboardModelResult.waitToLoad();

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
