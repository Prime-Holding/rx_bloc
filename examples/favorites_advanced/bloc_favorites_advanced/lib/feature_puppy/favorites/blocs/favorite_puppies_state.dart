part of 'favorite_puppies_bloc.dart';

enum FavoritePuppiesStatus { loading, success }

@immutable
abstract class FavoritePuppiesState extends Equatable {
  const FavoritePuppiesState();

  @override
  List<Object> get props => [];
}

class FavoritePuppiesListState extends FavoritePuppiesState {
  const FavoritePuppiesListState({
    required this.favoritePuppies,
  });

  final List<Puppy> favoritePuppies;

  FavoritePuppiesState copyWith({
    List<Puppy>? favoritePuppies,
  }) =>
      FavoritePuppiesListState(
        favoritePuppies: favoritePuppies ?? this.favoritePuppies,
      );

  @override
  List<Object> get props => [favoritePuppies];
}

class FavoritePuppyState extends FavoritePuppiesState {
  const FavoritePuppyState({
    required this.favoritePuppy,
    required this.status,
  });

  final Puppy favoritePuppy;
  final FavoritePuppiesStatus status;

  @override
  List<Object> get props => [favoritePuppy];
}
