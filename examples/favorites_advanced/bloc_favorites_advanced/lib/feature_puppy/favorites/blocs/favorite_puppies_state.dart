part of 'favorite_puppies_bloc.dart';

@immutable
class FavoritePuppiesState {
  const FavoritePuppiesState({
    required this.favoritePuppies,
  });

  final List<Puppy>? favoritePuppies;

  // @override
  // List<Object?> get props => [favoritePuppies];
}
