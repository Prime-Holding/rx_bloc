part of 'favorite_puppies_bloc.dart';

@immutable
class FavoritePuppiesState extends Equatable {
  const FavoritePuppiesState({
    required this.favoritePuppies,
    this.error,
  });

  final List<Puppy> favoritePuppies;
  final String? error;

  int get count => favoritePuppies.length;

  FavoritePuppiesState copyWith({
    List<Puppy>? favoritePuppies,
    String? error,
  }) =>
      FavoritePuppiesState(
        favoritePuppies: favoritePuppies ?? this.favoritePuppies,
        error: error ,
      );

  @override
  List<Object?> get props => [favoritePuppies];
}
