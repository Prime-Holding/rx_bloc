part of 'favorite_puppies_bloc.dart';

@immutable
class FavoritePuppiesState extends Equatable {
  const FavoritePuppiesState({
    required this.favoritePuppies,
  });

  final List<Puppy> favoritePuppies;

  int get count => favoritePuppies.length;

  FavoritePuppiesState copyWith({
    List<Puppy>? favoritePuppies,
  }) =>
      FavoritePuppiesState(
        favoritePuppies: favoritePuppies ?? this.favoritePuppies,
      );

  @override
  List<Object?> get props => [favoritePuppies];
}
