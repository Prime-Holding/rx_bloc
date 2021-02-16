// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'favorite_puppies_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class FavoritePuppiesBlocType extends RxBlocTypeBase {
  FavoritePuppiesEvents get events;
  FavoritePuppiesStates get states;
}

/// [$FavoritePuppiesBloc] extended by the [FavoritePuppiesBloc]
/// {@nodoc}
abstract class $FavoritePuppiesBloc extends RxBlocBase
    implements
        FavoritePuppiesEvents,
        FavoritePuppiesStates,
        FavoritePuppiesBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [reloadFavoritePuppies]
  final _$reloadFavoritePuppiesEvent = BehaviorSubject.seeded(false);

  /// The state of [count] implemented in [_mapToCountState]
  Stream<int> _countState;

  @override
  void reloadFavoritePuppies({bool silently}) =>
      _$reloadFavoritePuppiesEvent.add(silently);

  @override
  Stream<int> get count => _countState ??= _mapToCountState();

  Stream<int> _mapToCountState();

  @override
  FavoritePuppiesEvents get events => this;

  @override
  FavoritePuppiesStates get states => this;

  @override
  void dispose() {
    _$reloadFavoritePuppiesEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
