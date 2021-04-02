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
  final _$filterByQueryEvent = BehaviorSubject.seeded('');

  /// Тhe [Subject] where events sink to by calling [filterByDateRange]
  final _$filterByDateRangeEvent = PublishSubject<DateTimeRange?>();

  /// Тhe [Subject] where events sink to by calling [reload]
  final _$reloadEvent = BehaviorSubject.seeded(
      const _ReloadEventArgs(reset: true, fullReset: false));

  @override
  void filterByQuery(String query) => _$filterByQueryEvent.add(query);

  @override
  void filterByDateRange(DateTimeRange? dateRange) =>
      _$filterByDateRangeEvent.add(dateRange);

  @override
  void reload({required bool reset, bool fullReset = false}) =>
      _$reloadEvent.add(_ReloadEventArgs(reset: reset, fullReset: fullReset));

  @override
  HotelListEvents get events => this;

  @override
  HotelListStates get states => this;

  @override
  void dispose() {
    _$filterByQueryEvent.close();
    _$filterByDateRangeEvent.close();
    _$reloadEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [HotelListEvents.reload] event
class _ReloadEventArgs {
  const _ReloadEventArgs({required this.reset, this.fullReset = false});

  final bool reset;

  final bool fullReset;
}
