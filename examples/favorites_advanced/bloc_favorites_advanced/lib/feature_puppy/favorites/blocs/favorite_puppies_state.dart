part of 'favorite_puppies_bloc.dart';

// abstract class FavoritePuppiesState extends Equatable {
//   const FavoritePuppiesState();
//
//   // get favoritePuppies => null;
// }

@immutable
class FavoritePuppiesState extends Equatable {
  const FavoritePuppiesState({
    required this.favoritePuppies,
  });

  final List<Puppy>? favoritePuppies;

  FavoritePuppiesState copyWith({
    List<Puppy>? favoritePuppies,
  }) =>
      FavoritePuppiesState(
        favoritePuppies: favoritePuppies ?? this.favoritePuppies,
      );

  @override
  List<Object?> get props => [favoritePuppies];
}

// class FavoritePuppyState extends FavoritePuppiesState {
//   const FavoritePuppyState({
//     required this.favoritePuppy,
//   });
//
//   final Puppy favoritePuppy;
//
//   @override
//   List<Object?> get props => [favoritePuppy];
// }
