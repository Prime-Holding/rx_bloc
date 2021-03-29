// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'favorite_hotels_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class FavoriteHotelsBlocType extends RxBlocTypeBase {
  FavoriteHotelsEvents get events;
  FavoriteHotelsStates get states;
}

/// [$FavoriteHotelsBloc] extended by the [FavoriteHotelsBloc]
/// {@nodoc}
abstract class $FavoriteHotelsBloc extends RxBlocBase
    implements
        FavoriteHotelsEvents,
        FavoriteHotelsStates,
        FavoriteHotelsBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [reloadFavoriteHotels]
  final _$reloadFavoriteHotelsEvent = BehaviorSubject.seeded(false);

  /// The state of [count] implemented in [_mapToCountState]
  late final Stream<int> _countState = _mapToCountState();

  @override
  void reloadFavoriteHotels({required bool silently}) =>
      _$reloadFavoriteHotelsEvent.add(silently);

  @override
  Stream<int> get count => _countState;

  Stream<int> _mapToCountState();

  @override
  FavoriteHotelsEvents get events => this;

  @override
  FavoriteHotelsStates get states => this;

  @override
  void dispose() {
    _$reloadFavoriteHotelsEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
