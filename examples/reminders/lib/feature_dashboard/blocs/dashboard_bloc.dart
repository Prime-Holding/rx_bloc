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
  void fetchDashboardData([bool silently = false]);

  void fetchDataPaginated({required bool silently});
}

/// A contract class containing all states of the DashboardBloC.
abstract class DashboardBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;

  Stream<Result<DashboardCountersModel>> get dashboardCounters;

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
        .bind(_dashboardCountersResult)
        .addTo(_compositeSubscription);

    _$fetchDataPaginatedEvent
        .startWith(false)
        .fetchReminderModels(_dashboardService, _reminderModelsPaginated)
        .setResultStateHandler(this)
        .mergeWithPaginatedList(_reminderModelsPaginated)
        .bind(_reminderModelsPaginated)
        .addTo(_compositeSubscription);

    _coordinatorBloc
        .mapReminderManageEventsWithLatestFrom(
          _reminderModelsPaginated,
          operationCallback: _dashboardService.getManageOperation,
        )
        .map((event) => event.list as PaginatedList<ReminderModel>)
        .map(
          (list) => list.copyWith(
            list: list.list.sorted(
              (a, b) => a.dueDate.compareTo(b.dueDate),
            ),
          ),
        )
        .bind(_reminderModelsPaginated)
        .addTo(_compositeSubscription);

    _coordinatorBloc
        .mapReminderManagedEventsToCounterOperation()
        .map(counterOperationToDashboardCounters)
        .doOnData((event) {
          if (event is ResultSuccess<DashboardCountersModel>) {
            final updatedCounters = UpdatedCounters(
              incomplete: event.data.incompleteCount,
              complete: event.data.completeCount,
            );
            _coordinatorBloc.events.updateCounters(updatedCounters);
          }
        })
        .bind(_dashboardCountersResult)
        .addTo(_compositeSubscription);
  }

  final DashboardService _dashboardService;
  final CoordinatorBlocType _coordinatorBloc;

  static const _tagSilently = 'silently';

  Result<DashboardCountersModel> counterOperationToDashboardCounters(
    CounterOperation operation,
  ) {
    final dashboard = _dashboardCountersResult.value;

    if (dashboard is ResultSuccess<DashboardCountersModel>) {
      return Result.success(
        _dashboardService.getCountersModelFromCounterOperation(
          dashboardCounters: dashboard.data,
          counterOperation: operation,
        ),
      );
    }

    return dashboard;
  }

  @override
  Stream<PaginatedList<ReminderModel>> _mapToReminderModelsState() =>
      _reminderModelsPaginated;

  @override
  Stream<Result<DashboardCountersModel>> _mapToDashboardCountersState() =>
      _dashboardCountersResult.where((resultModel) =>
          !(resultModel is ResultLoading && resultModel.tag == _tagSilently));

  final _reminderModelsPaginated =
      BehaviorSubject<PaginatedList<ReminderModel>>.seeded(
    PaginatedList<ReminderModel>(
      list: [],
      pageSize: 10,
    ),
  );

  final _dashboardCountersResult =
      BehaviorSubject<Result<DashboardCountersModel>>.seeded(Result.loading());

  @override
  Future<void> get refreshDone => _reminderModelsPaginated.waitToLoad();

  @override
  Stream<String> _mapToErrorsState() => errorState.toMessage();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  void dispose() {
    _dashboardCountersResult.close();
    _reminderModelsPaginated.close();
    super.dispose();
  }
}
