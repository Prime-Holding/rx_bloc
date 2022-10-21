// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'hotel_favorites_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class HotelFavoritesBlocType extends RxBlocTypeBase {
  HotelFavoritesBlocEvents get events;
  HotelFavoritesBlocStates get states;
}

/// [$HotelFavoritesBloc] extended by the [HotelFavoritesBloc]
/// {@nodoc}
abstract class $HotelFavoritesBloc extends RxBlocBase
    implements
        HotelFavoritesBlocEvents,
        HotelFavoritesBlocStates,
        HotelFavoritesBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [reloadFavoriteHotels]
  final _$reloadFavoriteHotelsEvent = BehaviorSubject<bool>.seeded(false);

  /// The state of [count] implemented in [_mapToCountState]
  late final Stream<int> _countState = _mapToCountState();

  @override
  void reloadFavoriteHotels({required bool silently}) =>
      _$reloadFavoriteHotelsEvent.add(silently);

  @override
  Stream<int> get count => _countState;

  Stream<int> _mapToCountState();

  @override
  HotelFavoritesBlocEvents get events => this;

  @override
  HotelFavoritesBlocStates get states => this;

  @override
  void dispose() {
    _$reloadFavoriteHotelsEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
