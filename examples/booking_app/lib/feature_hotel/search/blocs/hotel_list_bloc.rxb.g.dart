// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'hotel_list_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class HotelListBlocType extends RxBlocTypeBase {
  HotelListEvents get events;
  HotelListStates get states;
}

/// [$HotelListBloc] extended by the [HotelListBloc]
/// {@nodoc}
abstract class $HotelListBloc extends RxBlocBase
    implements HotelListEvents, HotelListStates, HotelListBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [filterByQuery]
  final _$filterByQueryEvent = BehaviorSubject<String>.seeded('');

  /// Тhe [Subject] where events sink to by calling [filterByDateRange]
  final _$filterByDateRangeEvent = BehaviorSubject<DateTimeRange?>.seeded(null);

  /// Тhe [Subject] where events sink to by calling [filterByCapacity]
  final _$filterByCapacityEvent =
      BehaviorSubject<_FilterByCapacityEventArgs>.seeded(
          const _FilterByCapacityEventArgs(roomCapacity: 0, personCapacity: 0));

  /// Тhe [Subject] where events sink to by calling [reload]
  final _$reloadEvent = BehaviorSubject<_ReloadEventArgs>.seeded(
      const _ReloadEventArgs(reset: true, fullReset: false));

  /// The state of [dateRangeFilterData] implemented in
  /// [_mapToDateRangeFilterDataState]
  late final Stream<DateRangeFilterData> _dateRangeFilterDataState =
      _mapToDateRangeFilterDataState();

  /// The state of [capacityFilterData] implemented in
  /// [_mapToCapacityFilterDataState]
  late final Stream<CapacityFilterData> _capacityFilterDataState =
      _mapToCapacityFilterDataState();

  @override
  void filterByQuery(String query) => _$filterByQueryEvent.add(query);

  @override
  void filterByDateRange({DateTimeRange? dateRange}) =>
      _$filterByDateRangeEvent.add(dateRange);

  @override
  void filterByCapacity({int roomCapacity = 0, int personCapacity = 0}) =>
      _$filterByCapacityEvent.add(_FilterByCapacityEventArgs(
          roomCapacity: roomCapacity, personCapacity: personCapacity));

  @override
  void reload({required bool reset, bool fullReset = false}) =>
      _$reloadEvent.add(_ReloadEventArgs(reset: reset, fullReset: fullReset));

  @override
  Stream<DateRangeFilterData> get dateRangeFilterData =>
      _dateRangeFilterDataState;

  @override
  Stream<CapacityFilterData> get capacityFilterData => _capacityFilterDataState;

  Stream<DateRangeFilterData> _mapToDateRangeFilterDataState();

  Stream<CapacityFilterData> _mapToCapacityFilterDataState();

  @override
  HotelListEvents get events => this;

  @override
  HotelListStates get states => this;

  @override
  void dispose() {
    _$filterByQueryEvent.close();
    _$filterByDateRangeEvent.close();
    _$filterByCapacityEvent.close();
    _$reloadEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [HotelListEvents.filterByCapacity] event
class _FilterByCapacityEventArgs {
  const _FilterByCapacityEventArgs(
      {this.roomCapacity = 0, this.personCapacity = 0});

  final int roomCapacity;

  final int personCapacity;
}

/// Helps providing the arguments in the [Subject.add] for
/// [HotelListEvents.reload] event
class _ReloadEventArgs {
  const _ReloadEventArgs({required this.reset, this.fullReset = false});

  final bool reset;

  final bool fullReset;
}
