// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'favorite_puppies_bloc.dart';

/// FavoritePuppiesBlocType class used for bloc event and state access from widgets
/// {@nodoc}
abstract class FavoritePuppiesBlocType extends RxBlocTypeBase {
  FavoritePuppiesEvents get events;

  FavoritePuppiesStates get states;
}

/// $FavoritePuppiesBloc class - extended by the FavoritePuppiesBloc bloc
/// {@nodoc}
abstract class $FavoritePuppiesBloc extends RxBlocBase
    implements
        FavoritePuppiesEvents,
        FavoritePuppiesStates,
        FavoritePuppiesBlocType {
  ///region Events

  ///region reloadFavoritePuppies

  final _$reloadFavoritePuppiesEvent = BehaviorSubject.seeded(false);
  @override
  void reloadFavoritePuppies({bool silently}) =>
      _$reloadFavoritePuppiesEvent.add(silently);

  ///endregion reloadFavoritePuppies

  ///endregion Events

  ///region States

  ///region count
  Stream<int> _countState;

  @override
  Stream<int> get count => _countState ??= _mapToCountState();

  Stream<int> _mapToCountState();

  ///endregion count

  ///endregion States

  ///region Type

  @override
  FavoritePuppiesEvents get events => this;

  @override
  FavoritePuppiesStates get states => this;

  ///endregion Type

  /// Dispose of all the opened streams
  void dispose() {
    _$reloadFavoritePuppiesEvent.close();
    super.dispose();
  }
}
