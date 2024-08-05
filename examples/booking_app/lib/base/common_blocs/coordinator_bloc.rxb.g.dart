// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'coordinator_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// @nodoc
abstract class CoordinatorBlocType extends RxBlocTypeBase {
  CoordinatorBlocEvents get events;
  CoordinatorBlocStates get states;
}

/// [$CoordinatorBloc] extended by the [CoordinatorBloc]
/// @nodoc
abstract class $CoordinatorBloc extends RxBlocBase
    implements
        CoordinatorBlocEvents,
        CoordinatorBlocStates,
        CoordinatorBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [hotelUpdated]
  final _$hotelUpdatedEvent = PublishSubject<Hotel>();

  /// Тhe [Subject] where events sink to by calling
  /// [hotelsWithExtraDetailsFetched]
  final _$hotelsWithExtraDetailsFetchedEvent = PublishSubject<List<Hotel>>();

  /// The state of [onHotelsUpdated] implemented in [_mapToOnHotelsUpdatedState]
  late final Stream<List<Hotel>> _onHotelsUpdatedState =
      _mapToOnHotelsUpdatedState();

  @override
  void hotelUpdated(Hotel hotel) => _$hotelUpdatedEvent.add(hotel);

  @override
  void hotelsWithExtraDetailsFetched(List<Hotel> hotels) =>
      _$hotelsWithExtraDetailsFetchedEvent.add(hotels);

  @override
  Stream<List<Hotel>> get onHotelsUpdated => _onHotelsUpdatedState;

  Stream<List<Hotel>> _mapToOnHotelsUpdatedState();

  @override
  CoordinatorBlocEvents get events => this;

  @override
  CoordinatorBlocStates get states => this;

  @override
  void dispose() {
    _$hotelUpdatedEvent.close();
    _$hotelsWithExtraDetailsFetchedEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
