// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'dashboard_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class DashboardBlocType extends RxBlocTypeBase {
  DashboardBlocEvents get events;
  DashboardBlocStates get states;
}

/// [$DashboardBloc] extended by the [DashboardBloc]
/// {@nodoc}
abstract class $DashboardBloc extends RxBlocBase
    implements DashboardBlocEvents, DashboardBlocStates, DashboardBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [fetchDashboardData]
  final _$fetchDashboardDataEvent = PublishSubject<bool>();

  /// Тhe [Subject] where events sink to by calling [fetchDataPaginated]
  final _$fetchDataPaginatedEvent = PublishSubject<bool>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String> _errorsState = _mapToErrorsState();

  /// The state of [dashboardCounters] implemented in
  /// [_mapToDashboardCountersState]
  late final Stream<Result<DashboardCountersModel>> _dashboardCountersState =
      _mapToDashboardCountersState();

  /// The state of [reminderModels] implemented in [_mapToReminderModelsState]
  late final Stream<PaginatedList<ReminderModel>> _reminderModelsState =
      _mapToReminderModelsState();

  @override
  void fetchDashboardData([bool silently = false]) =>
      _$fetchDashboardDataEvent.add(silently);

  @override
  void fetchDataPaginated({required bool silently}) =>
      _$fetchDataPaginatedEvent.add(silently);

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<String> get errors => _errorsState;

  @override
  Stream<Result<DashboardCountersModel>> get dashboardCounters =>
      _dashboardCountersState;

  @override
  Stream<PaginatedList<ReminderModel>> get reminderModels =>
      _reminderModelsState;

  Stream<bool> _mapToIsLoadingState();

  Stream<String> _mapToErrorsState();

  Stream<Result<DashboardCountersModel>> _mapToDashboardCountersState();

  Stream<PaginatedList<ReminderModel>> _mapToReminderModelsState();

  @override
  DashboardBlocEvents get events => this;

  @override
  DashboardBlocStates get states => this;

  @override
  void dispose() {
    _$fetchDashboardDataEvent.close();
    _$fetchDataPaginatedEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
