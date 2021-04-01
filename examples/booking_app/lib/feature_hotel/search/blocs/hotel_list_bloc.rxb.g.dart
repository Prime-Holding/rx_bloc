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

  /// Тhe [Subject] where events sink to by calling [filter]
  final _$filterEvent =
      BehaviorSubject.seeded(const _FilterEventArgs(query: ''));

  /// Тhe [Subject] where events sink to by calling [reload]
  final _$reloadEvent = BehaviorSubject.seeded(
      const _ReloadEventArgs(reset: true, fullReset: false));

  @override
  void filter({required String query, DateTimeRange? dateRange}) =>
      _$filterEvent.add(_FilterEventArgs(query: query, dateRange: dateRange));

  @override
  void reload({required bool reset, bool fullReset = false}) =>
      _$reloadEvent.add(_ReloadEventArgs(reset: reset, fullReset: fullReset));

  @override
  HotelListEvents get events => this;

  @override
  HotelListStates get states => this;

  @override
  void dispose() {
    _$filterEvent.close();
    _$reloadEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [HotelListEvents.filter] event
class _FilterEventArgs {
  const _FilterEventArgs({required this.query, this.dateRange});

  final String query;

  final DateTimeRange? dateRange;
}

/// Helps providing the arguments in the [Subject.add] for
/// [HotelListEvents.reload] event
class _ReloadEventArgs {
  const _ReloadEventArgs({required this.reset, this.fullReset = false});

  final bool reset;

  final bool fullReset;
}
