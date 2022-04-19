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

  /// Тhe [Subject] where events sink to by calling [fetchData]
  final _$fetchDataEvent = PublishSubject<void>();

  /// Тhe [Subject] where events sink to by calling [checkForUpdatedReminder]
  final _$checkForUpdatedReminderEvent = PublishSubject<List<ReminderModel>>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String> _errorsState = _mapToErrorsState();

  /// The state of [data] implemented in [_mapToDataState]
  late final Stream<Result<DashboardModel>> _dataState = _mapToDataState();

  /// The state of [updatedReminder] implemented in [_mapToUpdatedReminderState]
  late final Stream<ReminderModel?> _updatedReminderState =
      _mapToUpdatedReminderState();

  @override
  void fetchData() => _$fetchDataEvent.add(null);

  @override
  void checkForUpdatedReminder(List<ReminderModel> reminderModels) =>
      _$checkForUpdatedReminderEvent.add(reminderModels);

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<String> get errors => _errorsState;

  @override
  Stream<Result<DashboardModel>> get data => _dataState;

  @override
  Stream<ReminderModel?> get updatedReminder => _updatedReminderState;

  Stream<bool> _mapToIsLoadingState();

  Stream<String> _mapToErrorsState();

  Stream<Result<DashboardModel>> _mapToDataState();

  Stream<ReminderModel?> _mapToUpdatedReminderState();

  @override
  DashboardBlocEvents get events => this;

  @override
  DashboardBlocStates get states => this;

  @override
  void dispose() {
    _$fetchDataEvent.close();
    _$checkForUpdatedReminderEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
