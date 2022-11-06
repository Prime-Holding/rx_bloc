import 'package:collection/collection.dart';
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
  void fetchDashboardData([bool silently = false]);

  void fetchDataPaginated({required bool silently});
}

/// A contract class containing all states of the DashboardBloC.
abstract class DashboardBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;

  Stream<Result<DashboardModel>> get dashboardModel;

  Stream<PaginatedList<ReminderModel>> get reminderModels;

  /// Returns when the data refreshing has completed
  @RxBlocIgnoreState()
  Future<void> get refreshDone;
}

@RxBloc()
class DashboardBloc extends $DashboardBloc {
  DashboardBloc(this._dashboardService, this._coordinatorBloc) {
    _$fetchDashboardDataEvent
        .startWith(false)
        .fetchDashboardData(_dashboardService)
        .setResultStateHandler(this)
        .bind(_dashboardModelResult)
        .addTo(_compositeSubscription);

    _$fetchDataPaginatedEvent
        .startWith(false)
        .fetchReminderModels(_dashboardService, _dashboardModelPaginated)
        .setResultStateHandler(this)
        .mergeWithPaginatedList(_dashboardModelPaginated)
        .bind(_dashboardModelPaginated)
        .addTo(_compositeSubscription);

    _coordinatorBloc
        .mapReminderManageEventsWithLatestFrom(
          _dashboardModelPaginated.map((dashboardList) => dashboardList),
          operationCallback: _dashboardService.getManageOperation,
        )
        .map(managedListToDashboard)
        .doOnData((event) {
          if (event is ResultSuccess<DashboardModel>) {
            final updatedCounters = UpdatedCounters(
              incomplete: event.data.incompleteCount,
              complete: event.data.completeCount,
            );
            _coordinatorBloc.events.updateCounters(updatedCounters);
          }
        })
        .bind(_dashboardModelResult)
        .addTo(_compositeSubscription);

    _coordinatorBloc
        .mapReminderManageEventsWithLatestFrom(
          _dashboardModelPaginated.map((dashboardList) => dashboardList),
          operationCallback: _dashboardService.getManageOperation,
        )
        .map((event) => event.managedList.list)
        .cast<PaginatedList<ReminderModel>>()
        .map(
          (list) => list.copyWith(
            list: list.list.sorted(
              (a, b) => a.dueDate.compareTo(b.dueDate),
            ),
          ),
        )
        .bind(_dashboardModelPaginated)
        .addTo(_compositeSubscription);
  }

  final DashboardService _dashboardService;
  final CoordinatorBlocType _coordinatorBloc;

  static const _tagSilently = 'silently';

  Result<DashboardModel> managedListToDashboard(
    ManagedListCounterOperation<ReminderModel> managedListCounterOperation,
  ) {
    final dashboard = _dashboardModelResult.value;

    if (dashboard is ResultSuccess<DashboardModel>) {
      return Result.success(
        _dashboardService.getDashboardModelFromManagedList(
          dashboard: dashboard.data,
          managedList: managedListCounterOperation.managedList,
          oldReminder: managedListCounterOperation.oldReminder,
          counterOperation: managedListCounterOperation.counterOperation,
        ),
      );
    }

    return dashboard;
  }

  @override
  Stream<PaginatedList<ReminderModel>> _mapToReminderModelsState() =>
      _dashboardModelPaginated;

  @override
  Stream<Result<DashboardModel>> _mapToDashboardModelState() =>
      _dashboardModelResult.where((resultModel) =>
          !(resultModel is ResultLoading && resultModel.tag == _tagSilently));

  final _dashboardModelPaginated =
      BehaviorSubject<PaginatedList<ReminderModel>>.seeded(
    PaginatedList<ReminderModel>(
      list: [],
      pageSize: 10,
    ),
  );

  final _dashboardModelResult =
      BehaviorSubject<Result<DashboardModel>>.seeded(Result.loading());

  @override
  Future<void> get refreshDone => _dashboardModelPaginated.waitToLoad();

  @override
  Stream<String> _mapToErrorsState() => errorState.toMessage();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  void dispose() {
    _dashboardModelResult.close();
    _dashboardModelPaginated.close();
    super.dispose();
  }
}
